const { pathsToModuleNameMapper } = require('ts-jest/utils');
const { compilerOptions } = require('./tsconfig');

module.exports = {
  preset: 'ts-jest',
  transform: {
    '.(ts|tsx)': 'ts-jest',
  },
  moduleDirectories: ['node_modules', '.'],
  moduleNameMapper: pathsToModuleNameMapper(compilerOptions.paths),
  testTimeout: 30000,
};
