module.exports = {
  rules: {
    // require all requires be top-level
    // https://github.com/eslint-community/eslint-plugin-n/blob/masters/rules/global-require
    'n/global-require': 'error',

    // disallow use of new operator with the require function
    'n/no-new-require': 'error',

    // disallow string concatenation with __dirname and __filename
    // https://github.com/eslint-community/eslint-plugin-n/blob/master/docs/rules/no-path-concat.md
    'n/no-path-concat': 'error',

    // disallow process.exit()
    'n/no-process-exit': 'off',

    // Disable import rules as we have the specific import plugin for that
    'n/no-missing-import': 'off',
    'n/no-missing-require': 'off',
  },
};
