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
    // 禁用原有規則，因為我們有自定義需求
    'subject-case': [0],
    'subject-full-stop': [0],
    // 自定義規則：要求 commit message 必須以 #<issue number> 結尾
    'issue-number-required': [2, 'always']
  },
  plugins: [
    {
      rules: {
        'issue-number-required': (parsed) => {
          // 檢查 parsed 物件是否存在且有 header 屬性
          if (!parsed || !parsed.header) {
            return [false, 'Commit message could not be parsed'];
          }

          const header = parsed.header;

          // 更嚴格的正則表達式：完整驗證 conventional commit 格式 + issue number
          const fullFormatRegex = /^(feat|fix|docs|style|refactor|perf|test|chore|ci)(\(.+\))?: .+ #\d+$/;

          if (!fullFormatRegex.test(header)) {
            return [
              false,
              'Commit message must follow format: "type(scope): description #issue-number" (e.g., "feat(auth): add login feature #123")'
            ];
          }

          return [true, ''];
        }
      }
    }
  ]
};