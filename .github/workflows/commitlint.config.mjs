// commitlint.config.mjs
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore', 'ci']
    ],
    // 禁用原有 subject-case 規則，因為我們會添加 #數字
    'subject-case': [0], // 0 = disable

    // 自定義 subject-full-stop，允許或不允許句號
    'subject-full-stop': [0],
    'header-max-length': [2, 'always', 100],
    'subject-empty': [2, 'never'],
    'type-case': [2, 'always', 'lower-case'],
    // Modify the subject-pattern rule to include a custom error message
    'subject-pattern': [
      2,        // level: 2 = error
      'always', // applicability: always

      // The regular expression
      /^((feat|fix|chore|docs|refactor|perf|test|build|ci|revert)(\(.+\))?: (.+))?( #\d+)$/,

      // Custom error message (add a string as the fourth element here)
      'Commit message subject must end with a space followed by #IssueNumber (e.g., feat(scope): message #123)',
    ],

  }
};
