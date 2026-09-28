import commonjs from '@rollup/plugin-commonjs';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import typescript from '@rollup/plugin-typescript';

/**
 * @typedef {import('rollup').RollupOptions} RollupOptions
 */

/**
 * @typedef {import('rollup').ModuleFormat} ModuleFormat
 */

/**
 *
 * @param {string} entrypoint
 * @param {ModuleFormat} format
 * @returns {RollupOptions}
 */
function getOptionsForEntrypoint(entrypoint, format) {
  return {
    input: `timetables-data-inserter/${entrypoint}.ts`,

    // Mark node modules as externals. Needed for knex's optional drivers.
    external: [/node_modules/],
    output: [
      {
        file: `dist/${entrypoint}.js`,
        format: format,
        sourcemap: true,
      },
    ],
    plugins: [
      nodeResolve({ exportConditions: ['node'] }),

      commonjs({
        include: ['./index.js', /node_modules/],
      }),

      typescript({
        tsconfig: './tsconfig-cli.json',
        compilerOptions: {
          outDir: './dist',
          declarationDir: './dist/types',
        },
        outputToFilesystem: true,
      }),
    ],
  };
}

/**
 * @type {import('rollup').RollupOptions[]}
 */
const config = [
  getOptionsForEntrypoint('index', 'es'),
  getOptionsForEntrypoint('cli', 'commonjs'),
];

export default config;
