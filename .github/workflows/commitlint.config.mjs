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
      // Add a robust check for parsed object and its subject property
      if (!parsed || typeof parsed.subject === 'undefined') {
        return [false, 'Commit message could not be parsed. Subject is missing.'];
      }

      const commitSubject = parsed.subject;
      const regex = /^((feat|fix|chore|docs|refactor|perf|test|build|ci|revert)(\(.+\))?: (.+))?( #\d+)$/;

      if (regex.test(commitSubject)) {
        return [true, ''];
      } else {
        return [
          false,
          'Commit message subject must end with a space followed by #IssueNumber (e.g., feat(scope): message #123).',
        ];
      }
    },  }
};
