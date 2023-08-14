import { timetablesDbConfig } from '@config';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { postQuery } from '@util/graphql';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { queryTable, setupDb } from '@util/setup';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { defaultTimetablesDataset } from 'hsl/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { hslTimetablesDbSchema } from 'hsl/timetablesdb/datasets/schema';
import {
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
} from 'hsl/timetablesdb/datasets/types';
import {
  buildDeleteSubstituteOperatingPeriodMutation,
  buildEditSubsituteOperatingPeriodMutation,
  buildInsertSubstituteOperatingPeriodMutation,
} from 'hsl/timetablesdb/mutations';
import { DateTime, Duration } from 'luxon';
import {
  HslTimetablesDatasetOutput,
  buildHslTimetablesDataset,
  createHslTableData,
} from 'timetables-data-inserter';

describe('Substitute operating periods', () => {
  let dbConnection: DbConnection;
  let builtDataset: HslTimetablesDatasetOutput;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
    builtDataset = buildHslTimetablesDataset(defaultTimetablesDataset);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(async () => {
    const tableData = createHslTableData(builtDataset);
    await setupDb(dbConnection, tableData);
  });

  const getSubstituteOperatingPeriods = () => {
    return queryTable(
      dbConnection,
      hslTimetablesDbSchema['service_calendar.substitute_operating_period'],
    );
  };

  const getSubstituteOperatingDaysByLineTypes = () => {
    return queryTable(
      dbConnection,
      hslTimetablesDbSchema[
        'service_calendar.substitute_operating_day_by_line_type'
      ],
    );
  };

  const getRowCounts = async () => {
    const periodRes = await getSubstituteOperatingPeriods();
    const periodsBeforeDelete = periodRes.rowCount;
    const dayRes = await getSubstituteOperatingDaysByLineTypes();
    const daysBeforeDelete = dayRes.rowCount;
    return [periodsBeforeDelete, daysBeforeDelete];
  };

  describe('Insert substitute operating period', () => {
    it('Period with one substitute day', async () => {
      const [periodCountBefore, dayCountBefore] = await getRowCounts();
      const inputData = {
        is_preset: false,
        period_name: 'Unusual Saturday for City Tram Service',
        substitute_operating_day_by_line_types: {
          data: [
            {
              type_of_line: TypeOfLine.CityTramService,
              superseded_date: DateTime.fromISO('2023-05-20'),
              substitute_day_of_week: 7,
            },
          ],
        },
      };

      const response = await postQuery(
        buildInsertSubstituteOperatingPeriodMutation([inputData]),
      );
      expectNoErrorResponse(response);

      const periodResponse = await getSubstituteOperatingPeriods();

      expect(periodResponse.rows).toContainEqual({
        substitute_operating_period_id: expect.any(String),
        period_name: 'Unusual Saturday for City Tram Service',
        is_preset: false,
      });

      const dayRes = await getSubstituteOperatingDaysByLineTypes();
      expect(dayRes.rows).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            type_of_line: TypeOfLine.CityTramService,
            superseded_date: DateTime.fromISO('2023-05-20'),
            substitute_day_of_week: 7,
            begin_datetime: DateTime.fromISO('2023-05-20T04:30:00.000+03:00'),
            end_datetime: DateTime.fromISO('2023-05-21T04:30:00.000+03:00'),
          }),
        ]),
      );

      const [periodCountAfter, dayCountAfter] = await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore + 1);
      expect(dayCountAfter).toEqual(dayCountBefore + 1);
    });

    describe('Overlapping time ranges for line types', () => {
      it('Overlapping time ranges for same line type throws error', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Duplicate substitute day and line type',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-01'),
                substitute_day_of_week: 7,
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_no_timespan_overlap',
        )(response);
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('Same day can have different line types', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Duplicate substitute day and line type',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.FerryService,
                superseded_date: DateTime.fromISO('2023-04-01'),
                substitute_day_of_week: 2,
              },
              {
                type_of_line: TypeOfLine.CityTramService,
                superseded_date: DateTime.fromISO('2023-04-01'),
                substitute_day_of_week: 2,
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectNoErrorResponse(response);

        const periodResponse = await getSubstituteOperatingPeriods();

        expect(periodResponse.rows).toContainEqual({
          substitute_operating_period_id: expect.any(String),
          period_name: 'Duplicate substitute day and line type',
          is_preset: false,
        });

        const dayRes = await getSubstituteOperatingDaysByLineTypes();

        expect(dayRes.rows).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              type_of_line: TypeOfLine.FerryService,
              superseded_date: DateTime.fromISO('2023-04-01'),
              substitute_day_of_week: 2,
              begin_datetime: DateTime.fromISO('2023-04-01T04:30:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
            }),
            expect.objectContaining({
              type_of_line: TypeOfLine.FerryService,
              superseded_date: DateTime.fromISO('2023-04-01'),
              substitute_day_of_week: 2,
              begin_datetime: DateTime.fromISO('2023-04-01T04:30:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
            }),
          ]),
        );
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 2);
      });
    });

    describe('unique dow', () => {
      it('Same day and same type of line is ok when time periods dont overlap', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Special Metro service',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.MetroService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: 7,
                begin_time: Duration.fromISO('PT8H5M'),
                end_time: Duration.fromISO('PT10H5M'),
              },
              {
                type_of_line: TypeOfLine.MetroService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: 7,
                begin_time: Duration.fromISO('PT12H5M'),
                end_time: Duration.fromISO('PT24H5M'),
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );
        expectNoErrorResponse(response);

        const periodResponse = await getSubstituteOperatingPeriods();

        expect(periodResponse.rows).toContainEqual({
          substitute_operating_period_id: expect.any(String),
          period_name: 'Special Metro service',
          is_preset: false,
        });

        const dayRes = await getSubstituteOperatingDaysByLineTypes();
        expect(dayRes.rows).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              type_of_line: TypeOfLine.MetroService,
              superseded_date: DateTime.fromISO('2023-04-02'),
              substitute_day_of_week: 7,
              begin_datetime: DateTime.fromISO('2023-04-02T08:05:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T10:05:00.000+03:00'),
            }),
            expect.objectContaining({
              type_of_line: TypeOfLine.MetroService,
              superseded_date: DateTime.fromISO('2023-04-02'),
              substitute_day_of_week: 7,
              begin_datetime: DateTime.fromISO('2023-04-02T12:05:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-03T00:05:00.000+03:00'),
            }),
          ]),
        );
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 2);
      });

      it('When superseded day and type of line are same but substitute day of week is different, throws error', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'TODO',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: 7,
                begin_time: Duration.fromISO('PT8H5M'),
                end_time: Duration.fromISO('PT10H5M'),
              },
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: null,
                begin_time: Duration.fromISO('PT12H5M'),
                end_time: Duration.fromISO('PT24H5M'),
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectErrorResponse('substitute_operating_day_by_line_type_unique_dow')(
          response,
        );
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });
    });

    describe('Substitute day of week in range', () => {
      it('Throws error when value not in range', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Day of week outside range',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: 10,
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectErrorResponse('substitute_operating_day_by_line_type_valid_dow')(
          response,
        );

        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('Null value is accepted value for substitute day of week', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Null value for substitute day of week',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                substitute_day_of_week: null,
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectNoErrorResponse(response);

        const periodResponse = await getSubstituteOperatingPeriods();

        expect(periodResponse.rows).toContainEqual({
          substitute_operating_period_id: expect.any(String),
          period_name: 'Null value for substitute day of week',
          is_preset: false,
        });

        const dayRes = await getSubstituteOperatingDaysByLineTypes();
        expect(dayRes.rows).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              type_of_line: TypeOfLine.StoppingBusService,
              superseded_date: DateTime.fromISO('2023-04-02'),
              substitute_day_of_week: null,
              begin_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-03T04:30:00.000+03:00'),
            }),
          ]),
        );
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 1);
      });
    });

    describe('Time must be within the limits', () => {
      it('Begin time must be within the time limits of the operating day', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Begin time out of limits',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                begin_time: Duration.fromISO('PT2H5M'),
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_valid_begin_time',
        )(response);
        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('Begin time must be before end time', async () => {
        const [periodCountBefore, dayCountBefore] = await getRowCounts();
        const inputData = {
          is_preset: false,
          period_name: 'Begin time out of limits',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.StoppingBusService,
                superseded_date: DateTime.fromISO('2023-04-02'),
                begin_time: Duration.fromISO('PT9H5M'),
                end_time: Duration.fromISO('PT8H5M'),
              },
            ],
          },
        };

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation([inputData]),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_valid_begin_time',
        )(response);

        const [periodCountAfter, dayCountAfter] = await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });
    });
    it('End time must be within the time limits of the operating day', async () => {
      const [periodCountBefore, dayCountBefore] = await getRowCounts();

      const inputData = {
        is_preset: false,
        period_name: 'End time out of limits',
        substitute_operating_day_by_line_types: {
          data: [
            {
              type_of_line: TypeOfLine.StoppingBusService,
              superseded_date: DateTime.fromISO('2023-04-02'),
              end_time: Duration.fromISO('PT29H5M'),
            },
          ],
        },
      };

      const response = await postQuery(
        buildInsertSubstituteOperatingPeriodMutation([inputData]),
      );

      expectErrorResponse(
        'substitute_operating_day_by_line_type_valid_end_time',
      )(response);

      const [periodCountAfter, dayCountAfter] = await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore);
      expect(dayCountAfter).toEqual(dayCountBefore);
    });
  });

  describe('Edit substitute operating period', () => {
    it('Edit period changes days by line type correctly', async () => {
      const [periodCountBefore, dayCountBefore] = await getRowCounts();
      const sopIdInDB =
        builtDataset._substitute_operating_periods.aprilFools
          .substitute_operating_period_id;

      const inputData: {
        periodsToInsert: Partial<SubstituteOperatingPeriod>[];
        periodsToDelete: UUID[];
        daysToInsert: Partial<SubstituteOperatingDayByLineType>[];
      } = {
        periodsToInsert: [
          {
            period_name: 'Not april fools',
            substitute_operating_period_id: sopIdInDB,
          },
        ],
        periodsToDelete: [sopIdInDB],
        daysToInsert: [
          {
            type_of_line: TypeOfLine.StoppingBusService,
            superseded_date: DateTime.fromISO('2023-04-02'),
            substitute_day_of_week: 7,
            begin_time: Duration.fromISO('PT8H5M'),
            end_time: Duration.fromISO('PT10H5M'),
            substitute_operating_period_id: sopIdInDB,
          },
        ],
      };
      const editResponse = await postQuery(
        buildEditSubsituteOperatingPeriodMutation(inputData),
      );
      expectNoErrorResponse(editResponse);

      // Substitute period is updated correctly
      const periodRes = await getSubstituteOperatingPeriods();
      expect(periodRes.rows).toContainEqual({
        substitute_operating_period_id: sopIdInDB,
        period_name: 'Not april fools',
        is_preset: false,
      });

      // Substitute days by line types is updated correctly
      const dayRes = await getSubstituteOperatingDaysByLineTypes();
      expect(dayRes.rows).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            type_of_line: TypeOfLine.StoppingBusService,
            superseded_date: DateTime.fromISO('2023-04-02'),
            substitute_day_of_week: 7,
            substitute_operating_period_id: sopIdInDB,
            end_datetime: DateTime.fromISO('2023-04-02T10:05:00.000+03:00'),
            begin_datetime: DateTime.fromISO('2023-04-02T08:05:00.000+03:00'),
            timezone: 'Europe/Helsinki',
            substitute_operating_day_by_line_type_id: expect.any(String),
          }),
        ]),
      );

      const [periodCountAfter, dayCountAfter] = await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore);
      expect(dayCountAfter).toEqual(dayCountBefore);
    });
  });

  describe('Delete substitute operating period', () => {
    it('should remove substitute operating period and day', async () => {
      const [periodCountBefore, dayCountBefore] = await getRowCounts();

      const deleteResponse = await postQuery(
        buildDeleteSubstituteOperatingPeriodMutation([
          builtDataset._substitute_operating_periods.aprilFools
            .substitute_operating_period_id,
        ]),
      );

      expectNoErrorResponse(deleteResponse);

      const [periodCountAfter, dayCountAfter] = await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore - 1);
      expect(dayCountAfter).toEqual(dayCountBefore - 1);
    });
  });
});
