const { rules } = require('./eslint/rules');

const ruleOverrides = {
  'no-underscore-dangle': 'off',
  'jest/expect-expect': 'off', // most of the tests call the assertions through an external function
};

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
    'plugin:eslint-comments/recommended',
    'plugin:jest/recommended',
    'plugin:jest-formatting/recommended',
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
  },
  plugins: ['@typescript-eslint', 'jest', 'jest-formatting', 'lodash'],
  ignorePatterns: ['dist/*'],
  rules: {
    ...rules,
    ...ruleOverrides,
  },
};
