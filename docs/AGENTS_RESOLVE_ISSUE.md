# 🔧 Workflow 1: Resolve Issue

**Trigger:** Human says "resolve issue #42" or "solve issue #42"
**Prerequisites:** None - this workflow handles complete issue resolution from start to finish

**🚨 CRITICAL: Before starting, read CONTRIBUTING.md for complete workflow details and README.md for project-specific tech stack and implementation constraints.**

## Step 1: Setup Branch

```bash
./scripts/start_issue.sh <issue-number>
```

This creates the proper branch and assigns the issue.

**📖 Refer to CONTRIBUTING.md Step 1 for detailed branch creation instructions.**

### Step 2: Test-First Development

1. **Write tests first** (mandatory - ≥80% coverage)
2. **Develop solution** to make tests pass
3. **Iterate** until feature is complete

**📖 MANDATORY: Read CONTRIBUTING.md Step 2 for test-first development requirements and README.md for project-specific implementation guidance.**

### Step 3: Complete Development

**🎯 For ongoing development work, use [Workflow 3: Development Flow](/docs/AGENTS_DEVELOPMENT.md) patterns**

Continue development until the issue is fully resolved:

```bash
# Commit freely during development - these will be cleaned up later
git commit -m "add user authentication tests"
git commit -m "implement login validation"
git commit -m "fix edge case for empty passwords"
git commit -m "add integration tests for auth flow"
git commit -m "refactor validation logic"
```

### Step 4: Create PR for Review

**📖 CRITICAL: Follow CONTRIBUTING.md Step 3 for exact process requirements.**

**4a. Create PR:**

**Prepare PR body:**

- Copy the template from `.github/PULL_REQUEST_TEMPLATE.md`
- Create `.PR_BODY.md` in the project root using your code editor
- Fill out all sections completely

**Create the PR:**

```bash
# Get the exact issue title for consistency
./scripts/get_issue_title.sh <issue-number>

# Create PR, add --push to eliminates the interactive prompt.
gh pr create \
  --title "<issue-title> #<issue-number>" \
  --body-file .PR_BODY.md \
  --base main
  --push

# Clean up the temporary file
rm .PR_BODY.md
```

**4b. Verification Checklist:**

- [ ] All tests pass
- [ ] Build succeeds
- [ ] Code follows standards (TOC at the top of files, functions >10 lines documented)
- [ ] Clean commit history with proper format
- [ ] PR template fully completed
- [ ] PR title matches issue title exactly + `#<issue-number>`

### Step 5: Clean Up

Your work is done. Ensure all temporary files are removed.
