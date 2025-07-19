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
#ENV_FILE="$SCRIPT_DIR/.env"
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

    # Get project number by name
    local project_number
    project_number=$(gh project list --owner "$owner" --format json | jq -r ".[] | select(.title == \"$project_name\") | .number" 2>/dev/null)

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

    local field_id
    field_id=$(gh project field-list "$project_number" --owner "$owner" --format json | jq -r ".[] | select(.name == \"$field_name\") | .id" 2>/dev/null)

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

    local option_id
    option_id=$(gh project field-list "$project_number" --owner "$owner" --format json | jq -r ".[] | select(.name == \"$field_name\") | .options[]? | select(.name == \"$option_name\") | .id" 2>/dev/null)

    if [ -z "$option_id" ] || [ "$option_id" = "null" ]; then
        echo -e "${YELLOW}⚠️ Warning: Could not find option '$option_name' for field '$field_name'.${NC}"
        return 1
    fi

    echo "$option_id"
}

# Function to get item ID for the issue in the project
get_issue_item_id() {
    local owner="$1"
    local project_number="$2"
    local issue_number="$3"

    local item_id
    item_id=$(gh project item-list "$project_number" --owner "$owner" --format json | jq -r ".[] | select(.content.type == \"Issue\" and .content.number == $issue_number) | .id" 2>/dev/null)

    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        return 1
    fi

    echo "$item_id"
}

# Function to add issue to project
add_issue_to_project() {
    local owner="$1"
    local project_number="$2"
    local issue_url="$3"

    echo "➕ Adding issue to project..."
    local item_id
    item_id=$(gh project item-add "$project_number" --owner "$owner" --url "$issue_url" --format json 2>/dev/null | jq -r '.id')

    if [ -z "$item_id" ] || [ "$item_id" = "null" ]; then
        echo -e "${RED}❌ Failed to add issue to project.${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Successfully added issue to project (Item ID: $item_id).${NC}"
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
    PROJECT_OWNER=$(gh repo view --json owner --jq '.owner.login' 2>/dev/null)
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
            echo "📊 Updating Status to 'In Progress'..."
            if STATUS_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "Status"); then
                if STATUS_OPTION_ID=$(get_option_id "$PROJECT_OWNER" "$PROJECT_NUM" "Status" "In Progress"); then
                    if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$STATUS_FIELD_ID" "$STATUS_OPTION_ID" "single-select"; then
                        echo -e "${GREEN}✅ Successfully updated Status to 'In Progress'.${NC}"
                    else
                        echo -e "${YELLOW}⚠️ Warning: Could not update Status field.${NC}"
                    fi
                fi
            fi

            # Update Priority to "P2"
            echo "⚡ Updating Priority to 'P2'..."
            if PRIORITY_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "Priority"); then
                if PRIORITY_OPTION_ID=$(get_option_id "$PROJECT_OWNER" "$PROJECT_NUM" "Priority" "P2"); then
                    if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$PRIORITY_FIELD_ID" "$PRIORITY_OPTION_ID" "single-select"; then
                        echo -e "${GREEN}✅ Successfully updated Priority to 'P2'.${NC}"
                    else
                        echo -e "${YELLOW}⚠️ Warning: Could not update Priority field.${NC}"
                    fi
                fi
            fi

            # Update Estimate to "1"
            echo "📏 Updating Estimate to '1'..."
            if ESTIMATE_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "Estimate"); then
                if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$ESTIMATE_FIELD_ID" "1" "number"; then
                    echo -e "${GREEN}✅ Successfully updated Estimate to '1'.${NC}"
                else
                    echo -e "${YELLOW}⚠️ Warning: Could not update Estimate field.${NC}"
                fi
            fi

            # Update Iteration to "Current"
            echo "🔄 Updating Iteration to 'Current'..."
            if ITERATION_FIELD_ID=$(get_field_id "$PROJECT_OWNER" "$PROJECT_NUM" "Iteration"); then
                if update_project_field "$PROJECT_OWNER" "$PROJECT_NUM" "$ITEM_ID" "$ITERATION_FIELD_ID" "current" "iteration"; then
                    echo -e "${GREEN}✅ Successfully updated Iteration to 'Current'.${NC}"
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