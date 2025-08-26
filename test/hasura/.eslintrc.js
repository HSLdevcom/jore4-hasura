const { baseRules, jestRules } = require('./eslint/rules');

module.exports = {
  env: {
    es2024: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:import/recommended',
    'plugin:import/warnings',
    'plugin:import/typescript',
    'plugin:@typescript-eslint/recommended',
    'plugin:@eslint-community/eslint-comments/recommended',
    'plugin:n/recommended-module',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 15,
    sourceType: 'module',
    project: true,
  },
  settings: {
    'import/resolver': {
      typescript: {
        project: __dirname,
      },
    },
    node: { version: '>=23.9.0' },
  },
  plugins: ['@typescript-eslint', 'lodash', 'n', '@stylistic'],
  ignorePatterns: ['dist/*'],
  rules: baseRules,

  overrides: [
    {
      files: ['**/*.spec.ts', 'jest/*.ts'],
      env: { jest: true },
      extends: ['plugin:jest/recommended'],
      plugins: ['jest'],
      rules: jestRules,
    },
  ],
};
