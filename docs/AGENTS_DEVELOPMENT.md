# 🔧 Workflow 3: Development Flow

<!--
===============================================
Document: AGENTS_DEVELOPMENT.md
Purpose: Guide AI assistants through ongoing development work and code improvements

Overview:
  - Context Assessment & Current State Analysis
  - Test-Driven Development (TDD) Application
  - Programming Best Practices
  - Iterative Development Process
  - Collaboration & Documentation
  - Quality Validation

Key Sections:
  1. Context Assessment → Understand current state and requirements
  2. Test-Driven Development → Test-first approach with approved commit types
  3. Programming Best Practices → Architecture, implementation, documentation
  4. Iterative Development → Problem-solving approach and commit strategy
  5. Collaboration & Documentation → Progress docs and code review prep
  6. Quality Validation → Final checks and completion criteria

Critical Dependencies:
  - CONTRIBUTING.md → Development guidelines, coding standards, testing requirements
  - README.md → Tech stack, implementation patterns, project-specific constraints
  - Approved commit types: feat, fix, docs, chore, refactor
===============================================
-->

**Trigger:** Human asks for development help, code improvements, feature implementation, or ongoing work on existing issue/branch
**Prerequisites:** Working on existing issue/feature (may or may not have existing commits)

**🚨 CRITICAL: Before starting, read CONTRIBUTING.md for development guidelines and README.md for project-specific tech stack and implementation constraints.**

## Step 1: Context Assessment

**Understand Current State:**

- [ ] Which issue/feature are we working on?
- [ ] What branch are we on? (`git branch --show-current`)
- [ ] What commits already exist? (`git log --oneline`)
- [ ] What's the current test status? (Run test suite)

**📖 Essential References (Read These):**

- **README.md** → Tech stack, implementation patterns, project-specific constraints
- **CONTRIBUTING.md** → Development guidelines, coding standards, testing requirements

### Step 2: Apply Test-Driven Development

**🚨 MANDATORY: Follow test-first approach for all development**

Approved Commit Types:

feat: New features, including performance improvements (will be added to Changelog)
fix: Bug fixes (will be added to Changelog)
docs: Documentation only changes
chore: Build, CI/CD, settings, tools (non-code changes)
refactor: Code improvement including tests & cleanup, no behavior change

```bash
# Add tests for new functionality first
git commit -m "refactor: add validation tests for edge cases #<issue-number>"

# Implement the functionality to make tests pass
git commit -m "feat: implement password strength validation #<issue-number>"

# Refactor and improve
git commit -m "refactor: extract validation logic to utility #<issue-number>"
```

**Test-First Benefits:**

- Clarifies requirements before implementation
- Ensures comprehensive test coverage (≥80%)
- Enables confident refactoring
- Documents expected behavior

### Step 3: Apply Programming Best Practices

**🔧 Development Approach:**

**3a. Architecture & Design:**

- Choose appropriate design patterns for the problem
- Follow existing codebase patterns and conventions
- Consider separation of concerns and modularity
- Plan for extensibility and maintainability

**3b. Implementation Excellence:**

- **Performance:** Consider efficiency and scalability implications
- **Security:** Follow security best practices for the tech stack
- **Error Handling:** Implement comprehensive error handling and edge cases
- **Code Quality:** Write clean, readable, and maintainable code

**3c. Documentation Standards:**

- Add TOC at the top of new/modified files
- Document functions >10 lines with clear comments
- Explain complex logic and business rules
- Update relevant documentation files

### Step 4: Iterative Development Process

**4a. Problem-Solving Approach:**

1. **Break down complex problems** into smaller, manageable pieces
2. **Research solutions** using documentation, existing codebase patterns
3. **Experiment and validate** your approach with tests
4. **Refactor and optimize** as you learn more about the problem
5. **Document your decisions** in commit messages and code comments

**4b. Commit Strategy During Development:**

Approved Commit Types:

feat: New features, including performance improvements (will be added to Changelog)
fix: Bug fixes (will be added to Changelog)
docs: Documentation only changes
chore: Build, CI/CD, settings, tools (non-code changes)
refactor: Code improvement including tests & cleanup, no behavior change

```bash
# Commit frequently with descriptive messages - these will be cleaned up later
git commit -m "chore: initial OAuth integration setup #<issue-number>"
git commit -m "fix: handle expired token edge case #<issue-number>"
git commit -m "feat: comprehensive input validation #<issue-number>"
git commit -m "refactor: add logging for authentication flow #<issue-number>"
git commit -m "refactor: add integration tests for login workflow #<issue-number>"
git commit -m "docs: update API documentation #<issue-number>"
```

**4c. Continuous Quality Checks:**

- [ ] All existing tests still pass
- [ ] New functionality is thoroughly tested (≥80% coverage)
- [ ] Code follows project conventions and standards
- [ ] Edge cases and error conditions are handled
- [ ] Performance implications considered
- [ ] Security vulnerabilities addressed

### Step 5: Collaboration & Documentation

**5a. Progress Documentation:**

- Document design decisions and rationale in commit messages
- Note challenges encountered and solutions implemented
- Ask questions for areas needing clarification in GitHub discussions or issues
- Highlight areas that need additional attention

**5b. Code Review Preparation:**

- Ensure code is self-documenting with clear variable/function names
- Add comments for complex business logic
- Verify all edge cases are tested
- Check that error messages are user-friendly

### Step 6: Quality Validation

**Final Checks Before Completion:**

- [ ] Issue #<number> requirements fully implemented
- [ ] All tests pass (both new and existing)
- [ ] Code quality meets project standards
- [ ] No breaking changes introduced
- [ ] Performance is acceptable
- [ ] Security considerations addressed
- [ ] Documentation is complete and accurate
- [ ] Ready for peer review

**✅ Completion Criteria:**
Your development work is complete when all requirements are implemented, thoroughly tested, and the code meets quality standards.

**🎯 Next Steps:**

- If working within Workflow 1(/docs/AGENTS_RESOLVE_ISSUE.md): Return to Step 4 (Create PR)
- If working independently: Consider creating a PR using Workflow 2(/docs/AGENTS_CREATE_PULL_REQUEST.md)
- If more development needed: Continue iterating through this workflow

**📝 Remember:** You are an experienced developer - trust your judgment on technical decisions while staying aligned with project patterns and standards. When in doubt, refer to existing codebase examples or ask questions in GitHub discussions.

---
