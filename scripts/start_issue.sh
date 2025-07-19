# scripts/start_issue.sh
#!/bin/bash
# This script uses GitHub CLI to create and check out a branch linked to an issue.
# Usage: ./start_issue.sh <issue-number>

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function to sanitize JSON by removing control characters
sanitize_json() {
    local input="$1"
    # Remove control characters (U+0000 through U+001F and DEL U+007F)
    echo "$input" | tr -d '\000-\037' | tr -d '\177'
}

# Load configuration from .env file
load_env_file() {
    local env_file="$1"

    if [ -f "$env_file" ]; then
        echo "📄 Loading configuration from $env_file..."
        # Read .env file and export variables
        while IFS='=' read -r key value; do
            # Skip empty lines and comments
            [[ -z "$key" || "$key" =~ ^#.*$ ]] && continue

            # Remove quotes from value if present
            value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

            # Export the variable
            export "$key"="$value"
        done < "$env_file"
        echo -e "${GREEN}✅ Configuration loaded successfully.${NC}"
    else
        echo -e "${YELLOW}⚠️ Warning: $env_file not found. Using default values.${NC}"
    fi
}

# Load environment variables from .env file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=".env"
load_env_file "$ENV_FILE"

# Configuration - these can be overridden in .env file
PROJECT_NAME="${PROJECT_NAME:-}"  # Your project name
PROJECT_OWNER="${PROJECT_OWNER:-}"  # Leave empty to use current repo owner
PROJECT_NUMBER="${PROJECT_NUMBER:-}"  # Leave empty to auto-detect by name
PROJECT_STATUS_FIELD="${PROJECT_STATUS_FIELD:-Status}"  # Status field name
PROJECT_PRIORITY_FIELD="${PROJECT_PRIORITY_FIELD:-Priority}"  # Priority field name
PROJECT_ESTIMATE_FIELD="${PROJECT_ESTIMATE_FIELD:-Estimate}"  # Estimate field name
PROJECT_ITERATION_FIELD="${PROJECT_ITERATION_FIELD:-Iteration}"  # Iteration field name
PROJECT_STATUS_VALUE="${PROJECT_STATUS_VALUE:-In Progress}"  # Status value to set
PROJECT_PRIORITY_VALUE="${PROJECT_PRIORITY_VALUE:-P2}"  # Priority value to set
PROJECT_ESTIMATE_VALUE="${PROJECT_ESTIMATE_VALUE:-1}"  # Estimate value to set
PROJECT_ITERATION_VALUE="${PROJECT_ITERATION_VALUE:-current}"  # Iteration value to set

if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Issue number is required.${NC}"
    echo "Usage: $0 <issue-number>"
    exit 1
fi

ISSUE="$1"

# Function to get project info
get_project_info() {
    local owner="$1"
    local project_name="$2"

    if [ -n "$PROJECT_NUMBER" ]; then
        echo "$PROJECT_NUMBER"
        return
    fi

    # Get project number by name with sanitized JSON
    local project_data
    project_data=$(gh project list --owner "$owner" --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠️ Warning: Failed to fetch projects for owner '$owner'.${NC}"
        return 1
    fi

    local sanitized_data
    sanitized_data=$(sanitize_json "$project_data")
    if ! echo "$sanitized_data" | jq empty 2>/dev/null; then
        echo -e "${YELLOW}⚠️ Warning: Invalid JSON data from projects list.${NC}"
        return 1
    fi

    local project_number
    project_number=$(echo "$sanitized_data" | jq -r ".[] | select(.title == \"$project_name\") | .number" 2>/dev/null)

    if [ -z "$project_number" ] || [ "$project_number" = "null" ]; then
        echo -e "${YELLOW}⚠️ Warning: Could not find project '$project_name' for owner '$owner'.${NC}"
        return 1
    fi

    echo "$project_number"
}

# Function to get field ID by name
get_field_id() {
    local owner="$1"
    local project_number="$2"
    local field_name="$3"

    local field_data
    field_data=$(gh project field-list "$project_number" --owner "$owner" --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        return 1
    fi

    local sanitized_data
    sanitized_data=$(sanitize_json "$field_data")
    if ! echo "$sanitized_data" | jq empty 2>/dev/null; then
        return 1
    fi

    local field_id
    field_id=$(echo "$sanitized_data" | jq -r ".[] | select(.name == \"$field_name\") | .id" 2>/dev/null)

    if [ -z "$field_id" ] || [ "$field_id" = "null" ]; then
        echo -e "${YELLOW}⚠️ Warning: Could not find field '$field_name' in project.${NC}"
        return 1
    fi

    echo "$field_id"
}

# Function to get option ID for single-select fields
get_option_id() {
    local owner="$1"
    local project_number="$2"
    local field_name="$3"
    local option_name="$4"

    local field_data
    field_data=$(gh project field-list "$project_number" --owner "$owner" --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        return 1
    fi

    local sanitized_data
    sanitized_data=$(sanitize_json "$field_data")
    if ! echo "$sanitized_data" | jq empty 2>/dev/null; then
        return 1
    fi

    local option_id
    option_id=$(echo "$sanitized_data" | jq -r ".[] | select(.name == \"$field_name\") | .options[]? | select(.name == \"$option_name\") | .id" 2>/dev/null)

    if [ -z "$option_id" ] || [ "$option_id" = "null" ]; then
        echo -e "${YELLOW}⚠️ Warning: Could not find option '$option_name' for field '$field_name'.${NC}"
        return 1
    fi

    echo "$option_id"
}

# Function to add issue to project
add_issue_to_project() {
    local owner="$1"
    local project_number="$2"
    local issue_url="$3"

    echo "➕ Adding issue to project..."
    local add_result
    add_result=$(gh project item-add "$project_number" --owner "$owner" --url "$issue_url" --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to add issue to project.${NC}"
        return 1
    fi

    local sanitized_result
    sanitized_result=$(sanitize_json "$add_result")
    if ! echo "$sanitized_result" | jq empty 2>/dev/null; then
        echo -e "${RED}❌ Invalid response when adding issue to project.${NC}"
        return 1
    fi

    local item_id
    item_id=$(echo "$sanitized_result" | jq -r '.id' 2>/dev/null)

    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo -e "${RED}❌ Failed to get item ID after adding to project.${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Successfully added issue to project (Item ID: $item_id).${NC}"
    echo "$item_id"
}

# Function to get item ID for the issue in the project
get_issue_item_id() {
    local owner="$1"
    local project_number="$2"
    local issue_number="$3"

    echo "🔍 Debug: Looking for issue #$issue_number in project $project_number for owner $owner..." >&2

    # First, let's get all items in the project with sanitized JSON
    local all_items_raw
    all_items_raw=$(gh project item-list "$project_number" --owner "$owner" --format json 2>&1)
    local gh_exit_code=$?

    echo "🔍 Debug: gh project item-list exit code: $gh_exit_code" >&2

    if [ $gh_exit_code -ne 0 ]; then
        echo "❌ Debug: GitHub CLI failed with exit code $gh_exit_code" >&2
        echo "❌ Debug: Error output: $all_items_raw" >&2
        return 1
    fi

    if [ -z "$all_items_raw" ]; then
        echo "❌ Debug: Empty response from gh project item-list" >&2
        return 1
    fi

    echo "🔍 Debug: Raw JSON length: ${#all_items_raw} characters" >&2

    # Sanitize the JSON data
    local all_items_json
    all_items_json=$(sanitize_json "$all_items_raw")

    echo "🔍 Debug: Sanitized JSON length: ${#all_items_json} characters" >&2

    # Additional check for valid JSON after sanitization
    local jq_check_output
    jq_check_output=$(echo "$all_items_json" | jq empty 2>&1)
    local jq_check_code=$?

    if [ $jq_check_code -ne 0 ]; then
        echo "❌ Debug: Invalid JSON after sanitization. jq error: $jq_check_output" >&2
        # Try alternative approach with sed sanitization
        all_items_json=$(echo "$all_items_raw" | sed 's/[\x00-\x1F\x7F]//g')
        jq_check_output=$(echo "$all_items_json" | jq empty 2>&1)
        jq_check_code=$?

        if [ $jq_check_code -eq 0 ]; then
            echo "🔧 Debug: Successfully sanitized JSON with sed" >&2
        else
            echo "❌ Debug: Both primary and alternative JSON parsing failed. Final jq error: $jq_check_output" >&2
            echo "🔍 Debug: First 500 chars of problematic JSON:" >&2
            echo "$all_items_json" | head -c 500 >&2
            return 1
        fi
    else
        echo "✅ Debug: JSON is valid after sanitization" >&2
    fi

    # FIXED: Extract the items array from the JSON structure
    local all_items
    all_items=$(echo "$all_items_json" | jq '.items' 2>/dev/null)

    if [ -z "$all_items" ] || [ "$all_items" = "null" ]; then
        echo "❌ Debug: Could not extract items array from JSON" >&2
        echo "🔍 Debug: JSON structure:" >&2
        echo "$all_items_json" | jq 'keys' 2>/dev/null >&2 || echo "Failed to get JSON keys" >&2
        return 1
    fi

    # Check if we have any items at all
    local total_items
    total_items=$(echo "$all_items" | jq length 2>/dev/null)
    echo "🔍 Debug: Total items in project: $total_items" >&2

    # Check specifically for issues
    local issue_count
    issue_count=$(echo "$all_items" | jq '[.[] | select(.content.type == "Issue")] | length' 2>/dev/null)
    echo "🔍 Debug: Total issues in project: $issue_count" >&2

    # Debug: Show JSON structure of first item (if any)
    echo "🔍 Debug: Structure of first item:" >&2
    echo "$all_items" | jq '.[0] | keys' 2>/dev/null >&2 || echo "No items or JSON parsing failed" >&2

    # Debug: Show all issues in the project (with detailed output)
    echo "📋 Debug: Issues in project:" >&2
    local issues_output
    issues_output=$(echo "$all_items" | jq -r '.[] | select(.content.type == "Issue") | "  Issue #\(.content.number): \(.content.title // "No title") (ID: \(.id))"' 2>&1)
    local issues_jq_code=$?

    if [ $issues_jq_code -eq 0 ] && [ -n "$issues_output" ]; then
        echo "$issues_output" | head -20 >&2
    else
        echo "❌ Debug: Failed to extract issues or no issues found. jq exit code: $issues_jq_code" >&2
        if [ -n "$issues_output" ]; then
            echo "❌ Debug: jq error: $issues_output" >&2
        fi

        # Try alternative approach to see what content types exist
        echo "🔍 Debug: All content types in project:" >&2
        echo "$all_items" | jq -r '.[] | .content.type // "NO_TYPE"' 2>/dev/null | sort | uniq -c >&2 || echo "Failed to get content types" >&2
    fi

    # Try different approaches to find the item ID
    local item_id

    # Method 1: Number comparison
    echo "🔍 Debug: Trying Method 1 (number comparison)..." >&2
    item_id=$(echo "$all_items" | jq -r ".[] | select(.content.type == \"Issue\" and (.content.number | tonumber) == ($issue_number | tonumber)) | .id" 2>/dev/null)
    echo "🔍 Debug: Method 1 result: '$item_id'" >&2

    # Method 2: String comparison as fallback
    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo "🔍 Debug: Trying Method 2 (string comparison)..." >&2
        item_id=$(echo "$all_items" | jq -r ".[] | select(.content.type == \"Issue\" and (.content.number | tostring) == \"$issue_number\") | .id" 2>/dev/null)
        echo "🔍 Debug: Method 2 result: '$item_id'" >&2
    fi

    # Method 3: Direct comparison without conversion
    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo "🔍 Debug: Trying Method 3 (direct comparison)..." >&2
        item_id=$(echo "$all_items" | jq -r ".[] | select(.content.type == \"Issue\" and .content.number == $issue_number) | .id" 2>/dev/null)
        echo "🔍 Debug: Method 3 result: '$item_id'" >&2
    fi

    # Method 4: Try without type filter to see if the issue exists with a different type
    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo "🔍 Debug: Trying Method 4 (without type filter)..." >&2
        local any_match
        any_match=$(echo "$all_items" | jq -r ".[] | select(.content.number == $issue_number) | \"Type: \(.content.type), Number: \(.content.number), ID: \(.id)\"" 2>/dev/null)
        if [ -n "$any_match" ]; then
            echo "🔍 Debug: Found matching item with different type: $any_match" >&2
        else
            echo "🔍 Debug: No matching item found with any type" >&2
        fi
    fi

    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo "❌ Debug: Issue #$issue_number not found with any method" >&2

        # Try to add the issue to the project first
        echo "🔧 Debug: Attempting to add issue to project..." >&2
        local repo_data
        repo_data=$(gh repo view --json url 2>/dev/null)
        if [ $? -eq 0 ]; then
            local sanitized_repo_data
            sanitized_repo_data=$(sanitize_json "$repo_data")
            local repo_url
            repo_url=$(echo "$sanitized_repo_data" | jq -r '.url' 2>/dev/null)

            if [ -n "$repo_url" ] && [ "$repo_url" != "null" ]; then
                local issue_url="$repo_url/issues/$issue_number"
                echo "🔧 Debug: Trying to add issue URL: $issue_url" >&2
                item_id=$(add_issue_to_project "$owner" "$project_number" "$issue_url")
                if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
                    echo "✅ Debug: Successfully added issue to project with item ID: $item_id" >&2
                    echo "$item_id"
                    return 0
                fi
            fi
        fi

        return 1
    fi

    echo "✅ Debug: Found issue #$issue_number with item ID: $item_id" >&2
    echo "$item_id"
}

# Function to update project field
update_project_field() {
    local owner="$1"
    local project_number="$2"
    local item_id="$3"
    local field_id="$4"
    local value="$5"
    local field_type="$6"  # text, number, single-select, iteration

    local update_cmd="gh project item-edit --id \"$item_id\" --project-id \"$project_number\" --field-id \"$field_id\""

    case "$field_type" in
        "text")
            update_cmd="$update_cmd --text \"$value\""
            ;;
        "number")
            update_cmd="$update_cmd --number \"$value\""
            ;;
        "single-select")
            update_cmd="$update_cmd --single-select-option-id \"$value\""
            ;;
        "iteration")
            if [ "$value" = "current" ]; then
                update_cmd="$update_cmd --iteration-current"
            else
                update_cmd="$update_cmd --iteration-id \"$value\""
            fi
            ;;
    esac

    eval "$update_cmd" 2>/dev/null
}

# Ensure user is logged in to GitHub CLI
if ! gh auth status &>/dev/null; then
    echo -e "${RED}❌ Error: You are not logged in to GitHub CLI. Run 'gh auth login' first.${NC}"
    exit 1
fi

# Check that issue exists
if ! gh issue view "$ISSUE" &>/dev/null; then
    echo -e "${RED}❌ Error: Issue #$ISSUE not found.${NC}"
    exit 1
fi

# Check for uncommitted changes before switching branches
echo "🔍 Checking for uncommitted changes..."
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ Error: You have uncommitted changes. Please commit or stash them before proceeding.${NC}"
    git status -s
    exit 1
fi
echo -e "${GREEN}✅ No uncommitted changes found.${NC}"

# Pull the latest changes from the remote main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "🔄 Switching to main branch and pulling latest changes..."
    git checkout main
fi
git pull origin main

# Use GitHub CLI to create and link the branch
echo -e "🚀 Creating a branch for issue #$ISSUE using 'gh issue develop'..."
gh issue develop "$ISSUE" --checkout --base main

# Print branch creation status
NEW_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${GREEN}✅ Branch '$NEW_BRANCH' created and linked to issue #$ISSUE.${NC}"

# Get current GitHub username
CURRENT_USER=$(gh api user --jq '.login' 2>/dev/null)
if [ -z "$CURRENT_USER" ]; then
    echo -e "${YELLOW}⚠️ Warning: Could not determine current GitHub username.${NC}"
else
    echo "👤 Current user: $CURRENT_USER"

    # Assign current user to the issue
    echo "📝 Assigning issue #$ISSUE to $CURRENT_USER..."
    if gh issue edit "$ISSUE" --add-assignee "$CURRENT_USER" 2>/dev/null; then
        echo -e "${GREEN}✅ Successfully assigned issue #$ISSUE to $CURRENT_USER.${NC}"
    else
        echo -e "${YELLOW}⚠️ Warning: Could not assign issue to $CURRENT_USER. You may not have permission or already be assigned.${NC}"
    fi
fi

# Remove "needs-triage" label if it exists
echo "🏷️ Checking for 'needs-triage' label..."
CURRENT_LABELS=$(gh issue view "$ISSUE" --json labels --jq '.labels[].name' 2>/dev/null)
if echo "$CURRENT_LABELS" | grep -q "needs-triage"; then
    echo "🗑️ Removing 'needs-triage' label from issue #$ISSUE..."
    if gh issue edit "$ISSUE" --remove-label "needs-triage" 2>/dev/null; then
        echo -e "${GREEN}✅ Successfully removed 'needs-triage' label.${NC}"
    else
        echo -e "${YELLOW}⚠️ Warning: Could not remove 'needs-triage' label. You may not have permission.${NC}"
    fi
else
    echo -e "${GREEN}✅ No 'needs-triage' label found on issue #$ISSUE.${NC}"
fi

# Project management section
echo -e "\n${BLUE}🎯 Managing project fields...${NC}"

# Get repo owner if not specified
if [ -z "$PROJECT_OWNER" ]; then
    REPO_DATA=$(gh repo view --json owner 2>/dev/null)
    if [ $? -eq 0 ]; then
        SANITIZED_REPO_DATA=$(sanitize_json "$REPO_DATA")
        PROJECT_OWNER=$(echo "$SANITIZED_REPO_DATA" | jq -r '.owner.login' 2>/dev/null)
    fi
fi

if [ -z "$PROJECT_OWNER" ]; then
    echo -e "${YELLOW}⚠️ Warning: Could not determine repository owner. Skipping project updates.${NC}"
else
    echo "🏢 Project owner: $PROJECT_OWNER"

    # Get project number
    if PROJECT_NUM=$(get_project_info "$PROJECT_OWNER" "$PROJECT_NAME"); then
        echo "📊 Project: $PROJECT_NAME (ID: $PROJECT_NUM)"

        # Get issue item ID in the project
        if ITEM_ID=$(get_issue_item_id "$PROJECT_OWNER" "$PROJECT_NUM" "$ISSUE"); then
            echo "🔗 Issue #$ISSUE found in project (Item ID: $ITEM_ID)"

            # Update Status to "In Progress"
            echo "📊 Updating Status to '$PROJECT_STATUS_VALUE'..."
            if STATUS_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_STATUS_FIELD"); then
                if STATUS_OPTION_ID=$(get_option_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_STATUS_FIELD" "$PROJECT_STATUS_VALUE"); then
                    if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$STATUS_FIELD_ID" "$STATUS_OPTION_ID" "single-select"; then
                        echo -e "${GREEN}✅ Successfully updated Status to '$PROJECT_STATUS_VALUE'.${NC}"
                    else
                        echo -e "${YELLOW}⚠️ Warning: Could not update Status field.${NC}"
                    fi
                fi
            fi

            # Update Priority
            echo "⚡ Updating Priority to '$PROJECT_PRIORITY_VALUE'..."
            if PRIORITY_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_PRIORITY_FIELD"); then
                if PRIORITY_OPTION_ID=$(get_option_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_PRIORITY_FIELD" "$PROJECT_PRIORITY_VALUE"); then
                    if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$PRIORITY_FIELD_ID" "$PRIORITY_OPTION_ID" "single-select"; then
                        echo -e "${GREEN}✅ Successfully updated Priority to '$PROJECT_PRIORITY_VALUE'.${NC}"
                    else
                        echo -e "${YELLOW}⚠️ Warning: Could not update Priority field.${NC}"
                    fi
                fi
            fi

            # Update Estimate
            echo "📏 Updating Estimate to '$PROJECT_ESTIMATE_VALUE'..."
            if ESTIMATE_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_ESTIMATE_FIELD"); then
                if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$ESTIMATE_FIELD_ID" "$PROJECT_ESTIMATE_VALUE" "number"; then
                    echo -e "${GREEN}✅ Successfully updated Estimate to '$PROJECT_ESTIMATE_VALUE'.${NC}"
                else
                    echo -e "${YELLOW}⚠️ Warning: Could not update Estimate field.${NC}"
                fi
            fi

            # Update Iteration
            echo "🔄 Updating Iteration to '$PROJECT_ITERATION_VALUE'..."
            if ITERATION_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "$PROJECT_ITERATION_FIELD"); then
                if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$ITERATION_FIELD_ID" "$PROJECT_ITERATION_VALUE" "iteration"; then
                    echo -e "${GREEN}✅ Successfully updated Iteration to '$PROJECT_ITERATION_VALUE'.${NC}"
                else
                    echo -e "${YELLOW}⚠️ Warning: Could not update Iteration field.${NC}"
                fi
            fi

        else
            echo -e "${YELLOW}⚠️ Issue #$ISSUE is not linked to the project '$PROJECT_NAME'. You may need to add it manually.${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Could not find or access project '$PROJECT_NAME'. Skipping project updates.${NC}"
    fi
fi

# Call cleanup script to remove old branches
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup_branches.sh"

if [ -x "$CLEANUP_SCRIPT" ]; then
    echo -e "\n🧹 Running branch cleanup script..."
    bash "$CLEANUP_SCRIPT"
else
    echo -e "\n${RED}⚠️ Warning: cleanup_branches.sh not found or not executable.${NC}"
fi

echo -e "\n${GREEN}🎉 Issue #$ISSUE is ready for development!${NC}"