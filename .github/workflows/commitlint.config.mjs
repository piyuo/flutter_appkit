// commitlint.config.mjs
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore', 'ci']
    ],
    'header-max-length': [2, 'always', 100],
    'subject-empty': [2, 'never'],
    'type-case': [2, 'always', 'lower-case'],
    // 禁用原有 subject-case 規則，因為我們會添加 #數字
    'subject-case': [0], // 0 = disable
    // 自定義 subject-full-stop，允許或不允許句號
    'subject-full-stop': [0],
    // The correct way to define a custom subject-pattern rule, including the error message
    'subject-pattern': (parsed) => {
      // The 'parsed' object contains parts of the commit message after parsing
      // e.g., parsed.subject, parsed.type, parsed.scope, etc.

      const commitSubject = parsed.subject;
      // Ensure commitSubject exists to avoid errors with empty commit messages
      if (!commitSubject) {
        return [false, 'Commit message subject cannot be empty.'];
      }

      // Define the regular expression, same as before
      // Note: If you do not use scope, the regex might need to be adjusted to
      // /^((feat|fix|...): (.+))?( #\d+)$/
      // If you intend scope to be optional, the current regex is correct.
      const regex = /^((feat|fix|chore|docs|refactor|perf|test|build|ci|revert)(\(.+\))?: (.+))?( #\d+)$/;

      if (regex.test(commitSubject)) {
        return [true, '']; // Rule passes
      } else {
        // Return your custom error message when the rule fails
        return [
          false,
          'Commit message subject must end with a space followed by #IssueNumber (e.g., feat(scope): message #123).',
        ];
      }
    },
  }
};
