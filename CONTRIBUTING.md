# Contributing Guidelines

We follow a **simplified GitHub Flow** with **rebase and merge** strategy for clean commit history and milestone-driven releases.

## 📋 Quick Start

- [Workflow Overview](#workflow-overview)
- [Issue and Milestone Management](#issue-and-milestone-management)
- [Development Process](#development-process)
- [Commit Management](#commit-management)
- [Pull Request Process](#pull-request-process)
- [Release Management](#release-management)
- [Code Standards](#code-standards)

## 🔄 Workflow Overview

Our workflow emphasizes **clean commit history** and **milestone-driven releases**:

```mermaid
gitGraph
    commit id: "v1.0.0"
    branch issue-17-fix-auth
    checkout issue-17-fix-auth
    commit id: "WIP: auth changes"
    commit id: "fix: typo"
    commit id: "refactor: cleanup"
    checkout main
    merge issue-17-fix-auth id: "fix: authentication bug in login flow"
    branch issue-25-add-feature
    checkout issue-25-add-feature
    commit id: "feat: new feature"
    checkout main
    merge issue-25-add-feature id: "feat: add user dashboard feature"
    commit id: "v1.1.0"
```

### Key Principles
- **One clean commit per issue** when merged to main
- **Rebase and merge only** - no merge commits
- **Milestone-driven releases** - all issues must belong to a milestone
- **Draft PRs for early collaboration** with reviewers

## 📊 Issue and Milestone Management

### Creating Issues
All work must begin with a GitHub Issue:

1. **Select milestone first** - Choose from available milestones
2. **Use issue templates** - Bug Report or Feature Request
3. **Fill out completely** - All template fields are required
4. **Estimate effort** - Use story points (1 point ≈ 2 hours, max 20 points per week)

### Large Feature Management
For complex features, we use **Epic + Sub-issues** approach:

1. **Epic Issue** - Main feature request with overview and background
2. **Team Planning** - Collaborative breakdown into sub-issues (1-2 days each)
3. **Sub-issue Creation** - Each with clear acceptance criteria
4. **Team Assignment** - Developers claim specific sub-issues
5. **Coordinated Development** - All sub-issues tracked in project board

#### Issue Types and Commit Prefixes:
| Issue Type      | Commit Prefix | Version Impact | Example                                 |
| --------------- | ------------- | -------------- | --------------------------------------- |
| Bug Report      | `fix:`        | Patch          | `fix: resolve payment gateway timeout`  |
| Feature Request | `feat:`       | Minor          | `feat: add user profile management`     |
| Documentation   | `docs:`       | None*          | `docs: update API authentication guide` |
| Refactoring     | `refactor:`   | None*          | `refactor: optimize database queries`   |
| Maintenance     | `chore:`      | None*          | `chore: update dependencies to latest`  |

*\*Does not trigger version bumps by release-please*

### Milestone Management
- **All issues must have a milestone** assigned before starting work
- **Milestones represent development cycles** - e.g., "Sprint 7 - Payment Integration"
- **Version numbers determined by release-please** based on commit types
- **Release when milestone complete** - all issues closed

## 🚀 Development Process

### 1. Create Issue Branch
1. Navigate to your assigned GitHub Issue
2. Click "Create a branch for this issue"
3. **Source**: Always branch from `main`
4. **Naming**: GitHub auto-generates (e.g., `17-fix-payment-gateway`)

### 2. Start with Draft PR (Recommended)
Create a **Draft PR** immediately for early collaboration:

```bash
# After first commit
git push -u origin <branch-name>
# Create Draft PR on GitHub
```

**Benefits of Draft PRs:**
- Early feedback from CODEOWNERS reviewers
- Discuss approach before implementation
- Avoid large changes at review time
- Track progress transparently

### 3. Development and Commits
During development, commit frequently with descriptive messages:

```bash
# Examples of work-in-progress commits
git commit -m "WIP: initial authentication setup"
git commit -m "add password validation logic"
git commit -m "fix: handle edge case for empty passwords"
git commit -m "refactor: extract validation functions"
git commit -m "docs: add authentication flow diagram"
```

## 📝 Commit Management

### Before Requesting Review
**Always clean up your commit history** using interactive rebase:

```bash
# Rebase and squash commits
git rebase -i main

# Example: Squash multiple commits into one clean commit
# Before:
# fix: initial auth setup
# refactor: cleanup code
# fix: handle edge cases
# docs: add comments

# After:
# fix: resolve authentication timeout issues
```

### Final Commit Requirements
Your **first commit** must follow release-please requirements:

- **Use conventional commit format**: `<type>: <description>`
- **Must be `feat:` or `fix:`** to trigger version updates
- **PR title must match first commit message**
- **Keep additional commits for reviewer context** (if any)

#### Good Examples:
```bash
feat: add user dashboard with activity metrics
fix: resolve payment gateway connection timeout
refactor: optimize database query performance
```

#### Bad Examples:
```bash
WIP: working on dashboard  # ❌ Not conventional format
Update code  # ❌ Not descriptive
feat add dashboard  # ❌ Missing colon
```

## 🔀 Pull Request Process

### Before Creating/Converting PR

1. **Sync with main branch**:
```bash
git fetch origin
git rebase origin/main
git push --force-with-lease origin <branch-name>
```

2. **Clean up commits** using interactive rebase
3. **Run all tests and linting** locally

### Creating the PR

Use our **PR template** which includes:

**Required Sections:**
- **Checklist** - Code standards, testing, documentation
- **Testing** - How changes were tested, evidence provided
- **Deployment Notes** - Any special deployment considerations
- **Reviewer Notes** - Specific areas for review focus

**Template automatically populated** when creating PR from issue branch.

#### PR Title Format:
```
<type>: <description>
```
**Must match your first commit message exactly**.

### Review Process

1. **CODEOWNERS automatically assigned** as reviewers
2. **Address feedback with additional commits** (don't squash during review)
3. **All CI checks must pass** before merge
4. **At least one approval required** from CODEOWNERS

### Merge Process

- **Only "Rebase and merge" allowed** - other options are disabled
- **Maintainer performs the merge** after approval
- **Branch automatically deleted** after merge

## 🏷️ Release Management

### Milestone Completion
When all issues in a milestone are completed:

1. **Release-please creates release PR** automatically
2. **Maintainer reviews and merges** release PR to main
3. **Automatic version bump and changelog** generation
4. **Git tag created** with version number
5. **CI/CD deployment triggered** automatically

### Version Strategy
Following **semantic versioning** (semver):

- **feat:** commits → Minor version bump (1.1.0 → 1.2.0)
- **fix:** commits → Patch version bump (1.1.0 → 1.1.1)
- **BREAKING CHANGE:** → Major version bump (1.1.0 → 2.0.0)

## 💡 Code Standards

### Quality Requirements
- **All linting warnings resolved** before review
- **Test coverage ≥ 80%** for new code
- **Unit tests required** for business logic
- **Integration tests required** for APIs

### Naming Conventions
- **Variables**: camelCase (JS/Dart) or snake_case (Python)
- **Functions**: Descriptive verbs (`getUserById`, `calculateTotal`)
- **Classes**: PascalCase (`UserService`, `PaymentGateway`)
- **Files**: kebab-case (`user-service.js`, `payment-gateway.py`)

### Best Practices
- **Functions under 20 lines** (max 50 lines)
- **Single responsibility principle**
- **Maximum 3 levels of nesting**
- **Meaningful comments explain why, not what**
- **Remove dead code** before PR

## 🛠️ Common Git Operations

### Interactive Rebase Example
```bash
# Start interactive rebase
git rebase -i main

# In the editor, change 'pick' to 'squash' or 's' for commits to combine
pick abc1234 feat: add user authentication
squash def5678 fix: handle edge cases
squash ghi9012 refactor: cleanup validation logic

# Result: One clean commit with all changes
```

### Handling Review Changes
```bash
# Make changes based on review feedback
git add .
git commit -m "address review feedback: improve error handling"

# Push changes (PR updates automatically)
git push origin <branch-name>
```

## 🔍 Tracing PR History After Rebase Merge

After rebase and merge, you'll see clean commits on main branch, but the PR discussion history is still accessible:

### Finding the Original PR
1. **From commit page**: Navigate to the commit on GitHub
2. **Look for PR reference**: You'll see `main(#PR-NUMBER)` below the commit title
3. **Click the PR link**: `#94` → Takes you to the original Pull Request
4. **View all discussions**: Code reviews, comments, and approval history

### Tracing Back to Issue
From the PR page, you can trace back further:
- **Branch reference**: Shows original branch like `93-docs-update-contributingmd`
- **Auto-linked issue**: Branch name starts with issue number (`93-docs-update...`)
- **Complete history**: Issue → Branch → PR → Commit

**Example trace path:**
```
Issue #93 → Branch 93-docs-update → PR #94 → Commit abc1234
```

This maintains full traceability while keeping main branch history clean.

## 🤔 FAQ

**Q: Should I squash commits during code review?**
A: No! Keep review changes as separate commits. Only clean up before initial review request.

**Q: What if I need to update my branch during review?**
A: Rebase on main if needed, but don't squash review feedback commits until after approval.

**Q: Can I work on multiple issues simultaneously?**
A: Yes, but each must have its own branch and milestone assignment.

**Q: What happens if CI fails after merge?**
A: Create a hotfix issue and follow the same process. No direct commits to main allowed.

**Q: How do I handle breaking changes?**
A: Include "BREAKING CHANGE:" in commit footer to trigger major version bump.

**Q: How do we handle large features?**
A: Use Epic + Sub-issues approach. Team collaboratively breaks down the epic into 1-2 day sub-issues, each developer claims specific sub-issues and creates their own branch + PR.

**Q: What about hotfixes for production issues?**
A: We don't use hotfix branches. All changes follow the standard workflow. Production issues are handled at the deployment level using CI/CD rollback capabilities.

**Q: How do I find PR discussions after rebase merge?**
A: Click the commit on GitHub, then click the `#PR-NUMBER` link below the commit title to view the original PR and all its discussions.

---

**Remember**: Clean history on main, detailed history during development! 🧹✨