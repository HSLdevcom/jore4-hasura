module.exports = {
  rules: {
    'no-use-before-define': 'off', // note you must disable the base rule as it can report incorrect errors: https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-use-before-define.md#how-to-use
    '@typescript-eslint/no-use-before-define': 'error', // require variables to be used before defined
    '@typescript-eslint/explicit-module-boundary-types': 'off', // don't require explicit return values for functions as usually TS can infer those
    'no-shadow': 'off', // this might report false positives with TS: https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-shadow.md#how-to-use
    '@typescript-eslint/no-shadow': ['error'], //
    '@typescript-eslint/no-unused-vars': [
      'error',
      { varsIgnorePattern: '^GQL' },
    ], // ignore graphql query/mutation/fragment definitions
    '@typescript-eslint/no-non-null-assertion': 'error',
    '@typescript-eslint/no-empty-function': 'error',
    '@typescript-eslint/prefer-nullish-coalescing': 'error',
  },
};
