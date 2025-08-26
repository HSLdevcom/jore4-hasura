module.exports = {
  rules: {
    // Original rules from Airbnb config

    // require camel case names
    camelcase: ['error', { properties: 'never', ignoreDestructuring: false }],

    // enforce newline at the end of file, with no multiple empty lines
    '@stylistic/eol-last': ['error', 'always'],

    // require function expressions to have a name
    // https://eslint.org/docs/rules/func-names
    'func-names': 'warn',

    // require or disallow an empty line between class members
    // https://eslint.style/rules/rules/lines-between-class-members
    '@stylistic/lines-between-class-members': ['error', 'always'],

    // require a capital letter for constructors
    'new-cap': ['error', { capIsNew: false }],

    // disallow the omission of parentheses when invoking a constructor with no arguments
    //https://eslint.style/rules/new-parens
    '@stylistic/new-parens': 'error',

    // disallow use of bitwise operators
    // https://eslint.org/docs/rules/no-bitwise
    'no-bitwise': 'error',

    // disallow use of the continue statement
    // https://eslint.org/docs/rules/no-continue
    'no-continue': 'error',

    // disallow if as the only statement in an else block
    // https://eslint.org/docs/rules/no-lonely-if
    'no-lonely-if': 'error',

    // disallow use of chained assignment expressions
    // https://eslint.org/docs/rules/no-multi-assign
    'no-multi-assign': ['error'],

    // disallow multiple empty lines, only one newline at the end, and no new lines at the beginning
    // https://eslint.style/rules/no-multiple-empty-lines
    '@stylistic/no-multiple-empty-lines': [
      'error',
      { max: 1, maxBOF: 0, maxEOF: 0 },
    ],

    // disallow nested ternary expressions
    'no-nested-ternary': 'error',

    // disallow use of the Object constructor
    'no-object-constructor': 'error',

    // disallow certain syntax forms
    // https://eslint.org/docs/rules/no-restricted-syntax
    'no-restricted-syntax': [
      'error',
      {
        selector: 'ForInStatement',
        message:
          'for..in loops iterate over the entire prototype chain, which is virtually never what you want. Use Object.{keys,values,entries}, and iterate over the resulting array.',
      },
      {
        selector: 'ForOfStatement',
        message:
          'iterators/generators require regenerator-runtime, which is too heavyweight for this guide to allow them. Separately, loops should be avoided in favor of array iterations.',
      },
      {
        selector: 'LabeledStatement',
        message:
          'Labels are a form of GOTO; using them makes code confusing and hard to maintain and understand.',
      },
      {
        selector: 'WithStatement',
        message:
          '`with` is disallowed in strict mode because it makes code impossible to predict and optimize.',
      },
    ],

    // disallow dangling underscores in identifiers
    // https://eslint.org/docs/rules/no-underscore-dangle
    'no-underscore-dangle': ['error', { enforceInMethodNames: true }],

    // disallow the use of Boolean literals in conditional expressions
    // also, prefer `a || b` over `a ? a : b`
    // https://eslint.org/docs/rules/no-unneeded-ternary
    'no-unneeded-ternary': ['error', { defaultAssignment: false }],

    // disallow whitespace before properties
    // https://eslint.org/docs/rules/no-whitespace-before-property
    '@stylistic/no-whitespace-before-property': 'error',

    // allow just one var statement per function
    'one-var': ['error', 'never'],

    // require assignment operator shorthand where possible or prohibit it entirely
    // https://eslint.org/docs/rules/operator-assignment
    'operator-assignment': ['error', 'always'],

    // Disallow the use of Math.pow in favor of the ** operator
    // https://eslint.org/docs/rules/prefer-exponentiation-operator
    'prefer-exponentiation-operator': 'error',

    // Prefer use of an object spread over Object.assign
    // https://eslint.org/docs/rules/prefer-object-spread
    'prefer-object-spread': 'error',

    // require or disallow a space immediately following the // or /* in a comment
    // https://eslint.style/rules/spaced-comment
    '@stylistic/spaced-comment': [
      'error',
      'always',
      {
        line: {
          exceptions: ['-', '+'],
          markers: ['=', '!', '/'], // space here to support sprockets directives, slash for TS /// comments
        },
        block: {
          exceptions: ['-', '+'],
          markers: ['=', '!', ':', '::'], // space here to support sprockets directives and flow comment types
          balanced: true,
        },
      },
    ],

    // require or disallow the Unicode Byte Order Mark
    // https://eslint.org/docs/rules/unicode-bom
    'unicode-bom': ['error', 'never'],

    // Jore overrides
    '@eslint-community/eslint-comments/no-unused-disable': 'error', // ban unused eslint-disable comments
    '@eslint-community/eslint-comments/disable-enable-pair': [
      'error',
      {
        // if eslint rules are disabled in the beginning of file, it usually means that it is done for a reason and it doesn't make sense to enable those again at the end of the file
        allowWholeFile: true,
      },
    ],
  },
};
