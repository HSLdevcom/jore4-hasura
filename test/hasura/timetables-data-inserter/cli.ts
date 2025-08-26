import { program } from 'commander';
import fs from 'fs';
import { ConnectionConfig } from 'pg';
import { insertDatasetFromJson as insertGenericDatasetFromJson } from './generic/data-insert';
import { insertDatasetFromJson as insertHslDatasetFromJson } from './hsl/data-insert';

const getHost = (host: string) => {
  // "localhost" does not currently seem to be working on node 18.
  if (host === 'localhost') {
    return '127.0.0.1';
  }
  return host;
};

const buildDbConfig = (
  options: Record<string, string>,
): ConnectionConfig | undefined => {
  const dbConfig = {
    host: getHost(options.host),
    port: options.port ? parseInt(options.port, 10) : undefined,
    database: options.database,
    user: options.user,
    password: options.password,
  };
  // Validate the database config.
  // Either all config options should be given or none at all (so default config is used).
  const hasSome = Object.values(dbConfig).some((i) => !!i);
  const hasAll = Object.values(dbConfig).every((i) => !!i);
  if (hasSome && !hasAll) {
    throw new Error('Some database config parameters missing');
  }
  if (!hasSome) {
    return undefined;
  }

  return dbConfig;
};

let stdin = '';
program
  .command('insert')
  .description(
    'Parses given timetables dataset and inserts it into the database. Note that the database is also truncated. ' +
      'The database config options can be omitted, in which case the default database config will be used.',
  )
  .argument('<schema>', 'which database schema to use, either generic or hsl')
  .argument(
    '[dataset-json]',
    'the dataset json file, passed either as stream or by file path.',
  )
  .option('--host <host>', 'The host for database config.')
  .option('--port <port>', 'The port for database config.')
  .option('--database <database>', 'The name of database for database config.')
  .option('--user <user>', 'The user for database config.')
  .option('--password <password>', 'The password for database config.')
  .action(async (schema, datasetJsonFilePath, options) => {
    let datasetJson = '';
    if (stdin) {
      datasetJson = stdin;
    } else {
      datasetJson = fs.readFileSync(datasetJsonFilePath).toString();
    }

    let result;
    if (schema === 'generic') {
      result = await insertGenericDatasetFromJson(
        datasetJson,
        buildDbConfig(options),
      );
    } else if (schema === 'hsl') {
      result = await insertHslDatasetFromJson(
        datasetJson,
        buildDbConfig(options),
      );
    } else {
      throw new Error(`Unrecognized schema ${schema}.`);
    }

    process.stdout.write(JSON.stringify(result, null, 2));
  });

// From https://github.com/tj/commander.js/issues/137
if (process.stdin.isTTY) {
  program.parse(process.argv);
} else {
  process.stdin.on('readable', () => {
    const chunk = process.stdin.read();
    if (chunk !== null) {
      stdin += chunk;
    }
  });
  process.stdin.on('end', () => {
    program.parse(process.argv);
  });
}
