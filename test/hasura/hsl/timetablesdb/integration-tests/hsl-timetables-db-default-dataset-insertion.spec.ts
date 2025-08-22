import * as config from '@config';
import * as db from '@util/db';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { setupDb } from '@util/setup';
import { defaultHslTimetablesDbData } from 'hsl/timetablesdb/datasets/defaultSetup';

describe('Inserting hsl timetables specific data', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  it('should insert defaultHslTimetablesDbData succesfully and fetch data from hsl timetables specific table', async () => {
    await setupDb(dbConnection, defaultHslTimetablesDbData);

    const response = await db.singleQuery(
      dbConnection,
      `SELECT * FROM service_calendar.substitute_operating_day_by_line_type`,
    );

    expect(response.rows.length).toBeGreaterThan(0);
  });
});
