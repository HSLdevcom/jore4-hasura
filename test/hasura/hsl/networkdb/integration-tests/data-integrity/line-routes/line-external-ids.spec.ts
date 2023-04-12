import * as config from '@config';
import * as dataset from '@util/dataset';
import {
  closeDbConnection,
  createDbConnection,
  DbConnection,
  truncate,
} from '@util/db';
import { addMutationWrapper } from '@util/graphql';
import { expectNoErrorResponse } from '@util/response';
import { mergeLists } from '@util/schema';
import { getPropNameArray, queryTable, setupDb } from '@util/setup';
import {
  defaultHslNetworkDbData,
  hslLines,
} from 'hsl/networkdb/datasets/defaultSetup';
import { buildHslLine } from 'hsl/networkdb/datasets/factories';
import { hslNetworkDbSchema } from 'hsl/networkdb/datasets/schema';
import {
  HslLine,
  hslLineProps,
  LineExternalId,
  lineExternalIdProps,
  VehicleMode,
} from 'hsl/networkdb/datasets/types';
import { last } from 'lodash';
import { post } from 'request-promise';

describe('service_pattern.scheduled_stop_point.external_id sequence', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(config.networkDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(() =>
    // The line_external_id table is not truncated with setupDb because there is no data inserted there (explicitly).
    // Doing the truncate here rather than changing the setupDb behavior seemed easier.
    truncate(dbConnection, 'route.line_external_id'),
  );

  beforeEach(async () => {
    // Use a specific amount of lines to ease testing.
    const testLines = hslLines.slice(0, 5);

    const hslNetworkDbData = mergeLists(
      defaultHslNetworkDbData,
      [
        {
          name: 'route.line',
          data: testLines,
        },
      ],
      (tableSchema) => tableSchema.name,
    );

    await setupDb(dbConnection, hslNetworkDbData);
  });

  const selectAllLineExternalIds = () => {
    return queryTable(
      dbConnection,
      hslNetworkDbSchema['route.line_external_id'],
      'ORDER BY external_id ASC',
    );
  };

  const buildUpdateLineMutation = (
    lineId: string,
    toBeUpdated: Partial<HslLine>,
  ) => `
    update_route_line(
      where: {
        line_id: {_eq: "${lineId}"}
      },
      _set: ${dataset.toGraphQlObject(toBeUpdated)}
    ) {
      returning {
        ${getPropNameArray(hslLineProps).join(',')}
      }
    }
  `;

  // Note: typically this is only done in Jore3 import, which uses SQL and not graphql.
  const buildInsertLineExplicitIdMutation = (
    lineExternalId: LineExternalId,
  ) => `
    insert_route_line_external_id(objects: ${dataset.toGraphQlObject(
      lineExternalId,
    )}) {
      returning {
        ${getPropNameArray(lineExternalIdProps).join(',')}
      }
    }
  `;

  const buildInsertLineMutation = (line: HslLine) => `
    insert_route_line(objects: ${dataset.toGraphQlObject(line, [
      'primary_vehicle_mode',
      'type_of_line',
      'transport_target',
    ])}) {
      returning {
        ${getPropNameArray(hslLineProps).join(',')}
      }
    }
  `;

  it('should create correct external ids for new entries', async () => {
    const response = await selectAllLineExternalIds();

    const expectedLabels = hslLines.map((l) => l.label);
    const expectedExternalIds = [2001, 2002, 2003, 2004, 2005];
    expect(response.rowCount).toBe(expectedLabels.length);

    // Not quite sure if the order of ids is deterministic or flaky, but anyway is not important.
    const actualLabels = response.rows
      .map((r: LineExternalId) => r.label)
      .sort();
    const actualExternalIds = response.rows
      .map((r: LineExternalId) => r.external_id)
      .sort();
    expect(actualLabels).toEqual(expectedLabels);
    expect(actualExternalIds).toEqual(expectedExternalIds);
  });

  it('should create correct external ids on label update', async () => {
    const initialLineExternalIds = await selectAllLineExternalIds();

    const lineToUpdate = hslLines[2];
    const toUpdate = {
      label: 'A555',
    };

    const updateResponse = await post({
      ...config.hasuraRequestTemplate,
      body: {
        query: addMutationWrapper(
          buildUpdateLineMutation(lineToUpdate.line_id, toUpdate),
        ),
      },
    });
    expectNoErrorResponse(updateResponse);

    const lineExternalIdsResponse = await selectAllLineExternalIds();
    expect(lineExternalIdsResponse.rowCount).toBe(
      initialLineExternalIds.rowCount + 1,
    );
    expect(last(lineExternalIdsResponse.rows)).toEqual({
      label: 'A555',
      external_id: 2006,
    });
  });

  it('should use existing external id row if one exists and not update sequence', async () => {
    const initialLineExternalIds = await selectAllLineExternalIds();

    // Insert two lines: one with label already existing (uses existing external id)
    // and one with label that doesn't (= creates new external id, for checking that sequence is incremented correctly).

    const lineWithExistingLabel = buildHslLine({
      label: hslLines[2].label,
      priority: 10,
      primary_vehicle_mode: VehicleMode.Bus,
    });
    const insertWithExistingLabelResponse = await post({
      ...config.hasuraRequestTemplate,
      body: {
        query: addMutationWrapper(
          buildInsertLineMutation(lineWithExistingLabel),
        ),
      },
    });
    expectNoErrorResponse(insertWithExistingLabelResponse);

    const lineWithDefaultNewLabel = buildHslLine({
      label: 'A222',
      priority: 10,
      primary_vehicle_mode: VehicleMode.Bus,
    });
    const insertWithNewLabelResponse = await post({
      ...config.hasuraRequestTemplate,
      body: {
        query: addMutationWrapper(
          buildInsertLineMutation(lineWithDefaultNewLabel),
        ),
      },
    });
    expectNoErrorResponse(insertWithNewLabelResponse);

    const lineExternalIdsResponse = await selectAllLineExternalIds();
    expect(lineExternalIdsResponse.rowCount).toBe(
      initialLineExternalIds.rowCount + 1,
    );
    expect(last(lineExternalIdsResponse.rows)).toEqual({
      label: 'A222',
      external_id: 2006,
    });
  });

  it('should be able to explicitly insert values before sequence range, and not have them interfere with sequence', async () => {
    const initialLineExternalIds = await selectAllLineExternalIds();

    const explicitLineExternalId: LineExternalId = {
      label: 'A111',
      external_id: 1337,
    };
    const lineWithExplicitExternalId = buildHslLine({
      label: 'A111',
      priority: 10,
      primary_vehicle_mode: VehicleMode.Bus,
    });
    const lineWithDefaultExternalLabel = buildHslLine({
      label: 'A222',
      priority: 10,
      primary_vehicle_mode: VehicleMode.Bus,
    });

    const insertResponse = await post({
      ...config.hasuraRequestTemplate,
      body: {
        query: addMutationWrapper(`
          insert_external_id: ${buildInsertLineExplicitIdMutation(
            explicitLineExternalId,
          )}
          explicit_external_id_insert: ${buildInsertLineMutation(
            lineWithExplicitExternalId,
          )}
          default_external_id_insert: ${buildInsertLineMutation(
            lineWithDefaultExternalLabel,
          )}
        `),
      },
    });
    expectNoErrorResponse(insertResponse);

    const lineExternalIdsResponse = await selectAllLineExternalIds();
    expect(lineExternalIdsResponse.rowCount).toBe(
      initialLineExternalIds.rowCount + 2,
    );
    expect(lineExternalIdsResponse.rows[0]).toEqual(explicitLineExternalId);
    expect(last(lineExternalIdsResponse.rows)).toEqual({
      label: 'A222',
      external_id: 2006,
    });
  });
});
