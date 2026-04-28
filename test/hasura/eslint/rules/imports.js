module.exports = {
  rules: {
    // Original rules from Airbnb config

    // do not allow a default import name to match a named export
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-named-as-default.md
    'import-x/no-named-as-default': 'error',

    // warn on accessing default export property names that are also named exports
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-named-as-default-member.md
    'import-x/no-named-as-default-member': 'error',

    // Forbid mutable exports
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-mutable-exports.md
    'import-x/no-mutable-exports': 'error',

    // Module systems:

    // disallow require()
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-commonjs.md
    'import-x/no-commonjs': 'error',

    // disallow AMD require/define
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-amd.md
    'import-x/no-amd': 'error',

    // Style guide:

    // disallow non-import statements appearing before import statements
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/first.md
    'import-x/first': 'error',

    // disallow duplicate imports
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-duplicates.md
    'import-x/no-duplicates': 'error',

    // Require a newline after the last import/require in a group
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/newline-after-import.md
    'import-x/newline-after-import': 'error',

    // Forbid import of modules using absolute paths
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-absolute-path.md
    'import-x/no-absolute-path': 'error',

    // Forbid require() calls with expressions
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-dynamic-require.md
    'import-x/no-dynamic-require': 'error',

    // Forbid Webpack loader syntax in imports
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-webpack-loader-syntax.md
    'import-x/no-webpack-loader-syntax': 'error',

    // Prevent importing the default as if it were named
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-named-default.md
    'import-x/no-named-default': 'error',

    // Forbid a module from importing itself
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-self-import.md
    'import-x/no-self-import': 'error',

    // Forbid cyclical dependencies between modules
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-cycle.md
    'import-x/no-cycle': ['error', { maxDepth: '∞' }],

    // Ensures that there are no useless path segments
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-useless-path-segments.md
    'import-x/no-useless-path-segments': ['error', { commonjs: true }],

    // Reports the use of import declarations with CommonJS exports in any module except for the main module.
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-import-module-exports.md
    'import-x/no-import-module-exports': [
      'error',
      {
        exceptions: [],
      },
    ],

    // Use this rule to prevent importing packages through relative paths.
    // https://github.com/un-ts/eslint-plugin-import-x/blob/master/docs/rules/no-relative-packages.md
    'import-x/no-relative-packages': 'error',

    // Jore overrides
    'import-x/prefer-default-export': 'off', // default exports are bad, prefer named exports: https://basarat.gitbook.io/typescript/master-1/defaultisbad
    'import-x/no-default-export': 'error', // default exports are bad, prefer named exports

    'import-x/extensions': [
      'error',
      'ignorePackages',
      // prevent importing .ts/.tsx files with file extension
      {
        ts: 'never',
        tsx: 'never',
      },
    ],
    'import-x/no-extraneous-dependencies': [
      'error',
      // allow importing dev dependencies in test files
      {
        devDependencies: [
          '**/*.spec.ts',
          '**/*.spec.tsx',
          './ui/src/utils/test-utils/**',
          './jest/*.ts',
        ],
      },
    ],
    // Sort members of each import, since import/order rule does not take care of that.
    'sort-imports': ['error', { ignoreDeclarationSort: true }],
    'import-x/order': [
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
          ['external', 'builtin'],
          'internal',
          'parent',
          'sibling',
          'index',
          'object',
        ],
      },
    ],

    // prefer importing individual lodash methods (e.g. `import map from 'lodash/map'` instead of whole lodash library (`import { map } from 'lodash'`) to minimize bundle size
    'lodash/import-scope': ['error', 'method'],
  },
};
