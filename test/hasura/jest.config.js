const { pathsToModuleNameMapper } = require('ts-jest');
const { compilerOptions } = require('./tsconfig');

const isHslSchema = process.env.HASURA_DATABASE_SCHEMA === 'hsl';
const hslTestRootFolder = '<rootDir>/hsl/';
const hslTimetablesDataInserterFolder =
  '<rootDir>/timetables-data-inserter/hsl';

const baseConfig = {
  preset: 'ts-jest',
  transform: {
    '.(ts|tsx)': 'ts-jest',
  },
  moduleDirectories: ['node_modules', '<rootDir>'],
  moduleNameMapper: pathsToModuleNameMapper(compilerOptions.paths),
  setupFilesAfterEnv: ['./jest/matchers.ts', './jest/testers.ts'],
  testTimeout: 30000,
};
const genericConfig = {
  ...baseConfig,
  testPathIgnorePatterns: [
    '/node_modules/',
    hslTestRootFolder,
    hslTimetablesDataInserterFolder,
  ],
};
const hslConfig = {
  ...baseConfig,
  roots: [hslTestRootFolder, hslTimetablesDataInserterFolder],
};

module.exports = isHslSchema ? hslConfig : genericConfig;
