const { createDefaultPreset } = require('ts-jest');

const isHslSchema = process.env.HASURA_DATABASE_SCHEMA === 'hsl';
const hslTestRootFolder = '<rootDir>/hsl/';
const hslTimetablesDataInserterFolder =
  '<rootDir>/timetables-data-inserter/hsl';

const baseConfig = {
  ...createDefaultPreset({
    diagnostics: {
      // Needed to suppress an error with TS6.
      // See https://github.com/kulshekhar/ts-jest/pull/5273 and related,
      // for further steps, once a proper fix gets added.
      ignoreCodes: [5107],
    },
  }),
  moduleDirectories: ['node_modules', '<rootDir>'],
  moduleNameMapper: {
    '^@config$': 'config.ts',
    '^@util/(.*)$': 'util/$1',
    '^generic/(.*)$': 'generic/$1',
    '^hsl/(.*)$': 'hsl/$1',
    '^timetables\\-data\\-inserter$': 'timetables-data-inserter/index.ts',
    '^timetables\\-data\\-inserter/(.*)$': 'timetables-data-inserter/$1',
  },
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
