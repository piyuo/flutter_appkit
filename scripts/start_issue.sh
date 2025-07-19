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