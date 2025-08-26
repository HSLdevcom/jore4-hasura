import js from '@eslint/js';
import comments from '@eslint-community/eslint-plugin-eslint-comments/configs';
import stylistic from '@stylistic/eslint-plugin';
import configPrettier from 'eslint-config-prettier/flat';
import importPlugin from 'eslint-plugin-import';
import lodash from 'eslint-plugin-lodash';
import n from 'eslint-plugin-n';
import jest from 'eslint-plugin-jest';
import globals from 'globals';
import tsEslint from 'typescript-eslint';
import { baseRules, jestRules } from './eslint/rules/index.js';

export default tsEslint.config(
  { ignores: ['dist/**'] },
  {
    files: ['**/*.ts'],
    extends: [
      js.configs.recommended,
      tsEslint.configs.recommended,
      importPlugin.flatConfigs.recommended,
      importPlugin.flatConfigs.typescript,
      comments.recommended,
      n.configs['flat/recommended-module'],
      configPrettier,
    ],
    languageOptions: {
      globals: {
        ...globals.es2024,
        ...globals.node,
      },
      parserOptions: {
        ecmaVersion: 15,
        sourceType: 'module',
        project: true,
      },
    },
    plugins: {
      js,
      lodash,
      '@stylistic': stylistic,
    },
    settings: {
      'import/resolver': {
        typescript: {
          project: './tsconfig.json',
        },
      },
      node: { version: '>=23.9.0' },
    },
    rules: baseRules,
  },
  {
    files: ['**/*.spec.ts', 'jest/*.ts'],
    plugins: { jest },
    languageOptions: {
      globals: jest.environments.globals.globals,
    },
    rules: {
      ...jest.configs.recommended.rules,
      ...jestRules,
    },
  },
);
