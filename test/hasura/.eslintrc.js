module.exports = {
  env: {
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'airbnb-base',
    'plugin:import/errors',
    'plugin:import/warnings',
    'plugin:import/typescript',
    'plugin:@typescript-eslint/recommended',
    'plugin:eslint-comments/recommended',
    'plugin:jest/recommended',
    'plugin:jest-formatting/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 12,
    sourceType: 'module',
  },
  settings: {
    'import/resolver': {
      typescript: {
        project: __dirname,
      },
    },
  },
  plugins: ['@typescript-eslint', 'jest', 'jest-formatting'],
  ignorePatterns: [
    'dist/*',
    'ui/src/generated/*.tsx',
    'test-db-manager/src/generated/*.ts',
    'test-db-manager/dist',
    'test-db-manager/ts-dist',
  ],
  rules: {
    'arrow-body-style': 'off', // allow writing arrow functions like () => { return ... } instead of forcing those to be () => (...)
    'no-use-before-define': 'off', // note you must disable the base rule as it can report incorrect errors: https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-use-before-define.md#how-to-use
    '@typescript-eslint/no-use-before-define': 'error', // require variables to be used before defined
    'import/prefer-default-export': 'off', // default exports are bad, prefer named exports: https://basarat.gitbook.io/typescript/main-1/defaultisbad
    'import/no-default-export': 'error', // default exports are bad, prefer named exports
    '@typescript-eslint/explicit-module-boundary-types': 'off', // don't require explicit return values for functions as usually TS can infer those
    'no-param-reassign': [
      'error',
      // ignore 'draft' as its convention to use that name with immer: https://immerjs.github.io/immer/
      // ignore 'state' as `redux-toolkit` handles state modifications with `immer`
      { props: true, ignorePropertyModificationsFor: ['draft', 'state'] },
    ],
    'no-shadow': 'off', // this might report false positives with TS: https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-shadow.md#how-to-use
    '@typescript-eslint/no-shadow': ['error'], //
    'no-underscore-dangle': 'off',
    'no-unused-expressions': ['error', { allowTernary: true }], // allow expressions like `booleanValue ? doSomething() : doSomethingElse()`
    'import/extensions': [
      'error',
      'ignorePackages',
      // prevent importing .ts/.tsx files with file extension
      {
        ts: 'never',
        tsx: 'never',
      },
    ],
    'import/no-extraneous-dependencies': [
      'error',
      // allow importing dev dependencies in test files
      {
        devDependencies: [
          '**/*.spec.ts',
          '**/*.spec.tsx',
          './ui/src/utils/test-utils/**',
        ],
      },
    ],
    'import/order': [
      // require imports to be sorted like vscode automatically does with its "organize imports" feature.
      // https://code.visualstudio.com/docs/languages/typescript#_organize-imports
      'error',
      {
        alphabetize: {
          order: 'asc',
          caseInsensitive: true,
        },
        'newlines-between': 'never',
        groups: [
          ['external', 'builtin', 'internal'],
          'parent',
          'sibling',
          'index',
          'object',
        ],
      },
    ],
    'eslint-comments/no-unused-disable': 'error', // ban unused eslint-disable comments
    'eslint-comments/disable-enable-pair': [
      'error',
      {
        // if eslint rules are disabled in the beginning of file, it usually means that it is done for a reason and it doesn't make sense to enable those again at the end of the file
        allowWholeFile: true,
      },
    ],
    'jest/expect-expect': 'off', // most of the tests call the assertions through an external function
  },
};
