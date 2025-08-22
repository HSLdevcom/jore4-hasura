const { rules: bestPractices } = require('./best-practices');
const { rules: errors } = require('./errors');
const { rules: node } = require('./node');
const { rules: style } = require('./style');
const { rules: variables } = require('./variables');
const { rules: es6 } = require('./es6');
const { rules: imports } = require('./imports');
const { rules: strict } = require('./strict');
const { rules: typescript } = require('./typescript');

module.exports = {
  rules: {
    ...bestPractices,
    ...errors,
    ...node,
    ...style,
    ...variables,
    ...es6,
    ...imports,
    ...strict,
    ...typescript,
  },
};
