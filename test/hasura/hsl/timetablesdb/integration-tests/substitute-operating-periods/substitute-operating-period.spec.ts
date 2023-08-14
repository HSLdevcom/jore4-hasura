import { timetablesDbConfig } from '@config';
import { DbConnection, closeDbConnection, createDbConnection } from '@util/db';
import { postQuery } from '@util/graphql';
import { expectErrorResponse, expectNoErrorResponse } from '@util/response';
import { queryTable, setupDb } from '@util/setup';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { defaultTimetablesDataset } from 'hsl/timetablesdb/datasets/defaultSetup/default-timetables-dataset';
import { hslTimetablesDbSchema } from 'hsl/timetablesdb/datasets/schema';
import {
  DayOfWeek,
  SubstituteOperatingDayByLineType,
  SubstituteOperatingPeriod,
} from 'hsl/timetablesdb/datasets/types';
import {
  InsertSubstituteOperatingPeriod,
  buildPartialDeleteSubstituteOperatingDayByLineType,
  buildPartialDeleteSubstituteOperatingPeriodMutation,
  buildPartialInsertSubstituteOperatingDayByLineType,
  buildPartialInsertSubstituteOperatingPeriodMutation,
  buildPartialUpsertSubstituteOperatingPeriod,
  wrapWithTimetablesMutation,
} from 'hsl/timetablesdb/mutations';
import { DateTime, Duration } from 'luxon';
import {
  HslTimetablesDatasetOutput,
  buildHslTimetablesDataset,
  createHslTableData,
} from 'timetables-data-inserter';

describe('substitute operating periods', () => {
  let dbConnection: DbConnection;
  let builtDataset: HslTimetablesDatasetOutput;

  let periodCountBefore: number;
  let dayCountBefore: number;

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
    const periodRowCount = periodRes.rowCount;
    const dayRes = await getSubstituteOperatingDaysByLineTypes();
    const dayRowCount = dayRes.rowCount;
    return { periodRowCount, dayRowCount };
  };

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
    builtDataset = buildHslTimetablesDataset(defaultTimetablesDataset);
  });

  afterAll(() => closeDbConnection(dbConnection));

  beforeEach(async () => {
    const tableData = createHslTableData(builtDataset);
    await setupDb(dbConnection, tableData);
    ({ periodRowCount: periodCountBefore, dayRowCount: dayCountBefore } =
      await getRowCounts());
  });

  describe('insert substitute operating period', () => {
    const buildInsertSubstituteOperatingPeriodMutation = (
      substituteOperatingPeriods: Partial<InsertSubstituteOperatingPeriod>[],
    ) =>
      wrapWithTimetablesMutation(
        buildPartialInsertSubstituteOperatingPeriodMutation(
          substituteOperatingPeriods,
        ),
      );

    it('should add period and days by line type correctly', async () => {
      const inputData = [
        {
          is_preset: false,
          period_name: 'Unusual Saturday for City Tram Service',
          substitute_operating_day_by_line_types: {
            data: [
              {
                type_of_line: TypeOfLine.CityTramService,
                superseded_date: DateTime.fromISO('2023-05-20'),
                substitute_day_of_week: DayOfWeek.Sunday,
              },
              {
                type_of_line: TypeOfLine.RegionalBusService,
                superseded_date: DateTime.fromISO('2023-05-20'),
                substitute_day_of_week: DayOfWeek.Sunday,
              },
            ],
          },
        },
      ];

      const response = await postQuery(
        buildInsertSubstituteOperatingPeriodMutation(inputData),
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
            substitute_day_of_week: DayOfWeek.Sunday,
            begin_datetime: DateTime.fromISO('2023-05-20T04:30:00.000+03:00'),
            end_datetime: DateTime.fromISO('2023-05-21T04:30:00.000+03:00'),
          }),
          expect.objectContaining({
            type_of_line: TypeOfLine.RegionalBusService,
            superseded_date: DateTime.fromISO('2023-05-20'),
            substitute_day_of_week: DayOfWeek.Sunday,
            begin_datetime: DateTime.fromISO('2023-05-20T04:30:00.000+03:00'),
            end_datetime: DateTime.fromISO('2023-05-21T04:30:00.000+03:00'),
          }),
        ]),
      );

      const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
        await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore + 1);
      expect(dayCountAfter).toEqual(dayCountBefore + 2);
    });

    describe('overlapping time ranges for line types', () => {
      it('should throw error when time ranges overlap with line type', async () => {
        const inputData = [
          {
            is_preset: false,
            period_name: 'Duplicate substitute day and line type',
            substitute_operating_day_by_line_types: {
              data: [
                {
                  type_of_line: TypeOfLine.StoppingBusService,
                  superseded_date: DateTime.fromISO('2023-04-01'),
                  substitute_day_of_week: DayOfWeek.Sunday,
                },
              ],
            },
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_no_timespan_overlap',
        )(response);
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('should allow overlapping time ranges for different line types', async () => {
        const inputData = [
          {
            is_preset: false,
            period_name: 'Duplicate substitute day and line type',
            substitute_operating_day_by_line_types: {
              data: [
                {
                  type_of_line: TypeOfLine.FerryService,
                  superseded_date: DateTime.fromISO('2023-04-01'),
                  substitute_day_of_week: DayOfWeek.Tuesday,
                },
                {
                  type_of_line: TypeOfLine.CityTramService,
                  superseded_date: DateTime.fromISO('2023-04-01'),
                  substitute_day_of_week: DayOfWeek.Tuesday,
                },
              ],
            },
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
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
              substitute_day_of_week: DayOfWeek.Tuesday,
              begin_datetime: DateTime.fromISO('2023-04-01T04:30:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
            }),
            expect.objectContaining({
              type_of_line: TypeOfLine.FerryService,
              superseded_date: DateTime.fromISO('2023-04-01'),
              substitute_day_of_week: DayOfWeek.Tuesday,
              begin_datetime: DateTime.fromISO('2023-04-01T04:30:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
            }),
          ]),
        );
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 2);
      });
    });

    describe('unique day of week', () => {
      it('should allow same day of week and type of line when time range do not overlap', async () => {
        const inputData = [
          {
            is_preset: false,
            period_name: 'Special Metro service',
            substitute_operating_day_by_line_types: {
              data: [
                {
                  type_of_line: TypeOfLine.MetroService,
                  superseded_date: DateTime.fromISO('2023-04-02'),
                  substitute_day_of_week: DayOfWeek.Sunday,
                  begin_time: Duration.fromISO('PT8H5M'),
                  end_time: Duration.fromISO('PT10H5M'),
                },
                {
                  type_of_line: TypeOfLine.MetroService,
                  superseded_date: DateTime.fromISO('2023-04-02'),
                  substitute_day_of_week: DayOfWeek.Sunday,
                  begin_time: Duration.fromISO('PT12H5M'),
                  end_time: Duration.fromISO('PT24H5M'),
                },
              ],
            },
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
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
              substitute_day_of_week: DayOfWeek.Sunday,
              begin_datetime: DateTime.fromISO('2023-04-02T08:05:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-02T10:05:00.000+03:00'),
            }),
            expect.objectContaining({
              type_of_line: TypeOfLine.MetroService,
              superseded_date: DateTime.fromISO('2023-04-02'),
              substitute_day_of_week: DayOfWeek.Sunday,
              begin_datetime: DateTime.fromISO('2023-04-02T12:05:00.000+03:00'),
              end_datetime: DateTime.fromISO('2023-04-03T00:05:00.000+03:00'),
            }),
          ]),
        );
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 2);
      });

      it('should throw error when superseded day and type of line are same but substitute day of week is different', async () => {
        const inputData = [
          {
            is_preset: false,
            period_name: 'Different day of week',
            substitute_operating_day_by_line_types: {
              data: [
                {
                  type_of_line: TypeOfLine.StoppingBusService,
                  superseded_date: DateTime.fromISO('2023-04-02'),
                  substitute_day_of_week: DayOfWeek.Sunday,
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
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
        );

        expectErrorResponse('substitute_operating_day_by_line_type_unique_dow')(
          response,
        );
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });
    });

    describe('substitute day of week in range', () => {
      it('should throw error when value is not in range', async () => {
        const inputData = [
          {
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
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
        );

        expectErrorResponse('substitute_operating_day_by_line_type_valid_dow')(
          response,
        );

        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('should accept null value for substitute day of week', async () => {
        const inputData = [
          {
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
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
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
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore + 1);
        expect(dayCountAfter).toEqual(dayCountBefore + 1);
      });
    });

    describe('time must be within the limits', () => {
      it('should throw error when begin time is not within the time limits of the operating day', async () => {
        const inputData = [
          {
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
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_valid_begin_time',
        )(response);
        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });

      it('should throw error when begin time is after end time', async () => {
        const inputData = [
          {
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
          },
        ];

        const response = await postQuery(
          buildInsertSubstituteOperatingPeriodMutation(inputData),
        );

        expectErrorResponse(
          'substitute_operating_day_by_line_type_valid_begin_time',
        )(response);

        const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
          await getRowCounts();
        expect(periodCountAfter).toEqual(periodCountBefore);
        expect(dayCountAfter).toEqual(dayCountBefore);
      });
    });
    it('should throw error when end time is not within the time limits of the operating day', async () => {
      const inputData = [
        {
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
        },
      ];

      const response = await postQuery(
        buildInsertSubstituteOperatingPeriodMutation(inputData),
      );

      expectErrorResponse(
        'substitute_operating_day_by_line_type_valid_end_time',
      )(response);

      const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
        await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore);
      expect(dayCountAfter).toEqual(dayCountBefore);
    });
  });

  describe('edit substitute operating period', () => {
    const buildEditSubsituteOperatingPeriodMutation = (input: {
      periodsToInsert: Partial<SubstituteOperatingPeriod>[];
      periodsToDelete: UUID[];
      daysToInsert: Partial<SubstituteOperatingDayByLineType>[];
    }) =>
      wrapWithTimetablesMutation(`
        ${buildPartialUpsertSubstituteOperatingPeriod(input.periodsToInsert)}
        ${buildPartialDeleteSubstituteOperatingDayByLineType(
          input.periodsToDelete,
        )}
        ${buildPartialInsertSubstituteOperatingDayByLineType(
          input.daysToInsert,
        )}
      `);

    it('should edit period and days by line type correctly', async () => {
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
            substitute_day_of_week: DayOfWeek.Sunday,
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
            substitute_day_of_week: DayOfWeek.Sunday,
            substitute_operating_period_id: sopIdInDB,
            end_datetime: DateTime.fromISO('2023-04-02T10:05:00.000+03:00'),
            begin_datetime: DateTime.fromISO('2023-04-02T08:05:00.000+03:00'),
            timezone: 'Europe/Helsinki',
            substitute_operating_day_by_line_type_id: expect.any(String),
          }),
        ]),
      );

      const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
        await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore);
      expect(dayCountAfter).toEqual(dayCountBefore);
    });

    it('should not modify database when mutation fails in multi mutation request', async () => {
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
            period_name: 'Overlapping days',
            substitute_operating_period_id: sopIdInDB,
          },
        ],
        periodsToDelete: [sopIdInDB],
        daysToInsert: [
          {
            type_of_line: TypeOfLine.StoppingBusService,
            superseded_date: DateTime.fromISO('2023-04-02'),
            substitute_day_of_week: DayOfWeek.Sunday,
            begin_time: Duration.fromISO('PT8H5M'),
            end_time: Duration.fromISO('PT10H5M'),
            substitute_operating_period_id: sopIdInDB,
          },
          {
            type_of_line: TypeOfLine.StoppingBusService,
            superseded_date: DateTime.fromISO('2023-04-02'),
            substitute_day_of_week: DayOfWeek.Sunday,
            begin_time: Duration.fromISO('PT8H5M'),
            end_time: Duration.fromISO('PT10H5M'),
            substitute_operating_period_id: sopIdInDB,
          },
        ],
      };
      const editResponse = await postQuery(
        buildEditSubsituteOperatingPeriodMutation(inputData),
      );
      expectErrorResponse(
        'substitute_operating_day_by_line_type_no_timespan_overlap',
      )(editResponse);

      // Substitute operating period is not updated
      const periodRes = await getSubstituteOperatingPeriods();
      expect(periodRes.rows).toContainEqual({
        substitute_operating_period_id: sopIdInDB,
        period_name: 'AprilFools substitute operating period',
        is_preset: false,
      });

      // Substitute days by line types are not updated
      const dayRes = await getSubstituteOperatingDaysByLineTypes();
      expect(dayRes.rows).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            type_of_line: TypeOfLine.StoppingBusService,
            superseded_date: DateTime.fromISO('2023-04-01'),
            substitute_day_of_week: DayOfWeek.Friday,
            substitute_operating_period_id: sopIdInDB,
            begin_datetime: DateTime.fromISO('2023-04-01T04:30:00.000+03:00'),
            end_datetime: DateTime.fromISO('2023-04-02T04:30:00.000+03:00'),
            timezone: 'Europe/Helsinki',
            substitute_operating_day_by_line_type_id: expect.any(String),
          }),
        ]),
      );

      const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
        await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore);
      expect(dayCountAfter).toEqual(dayCountBefore);
    });
  });

  describe('delete substitute operating period', () => {
    it('should remove substitute operating period and releted days by line type', async () => {
      const deleteResponse = await postQuery(
        wrapWithTimetablesMutation(
          buildPartialDeleteSubstituteOperatingPeriodMutation([
            builtDataset._substitute_operating_periods.aprilFools
              .substitute_operating_period_id,
          ]),
        ),
      );

      expectNoErrorResponse(deleteResponse);

      const { periodRowCount: periodCountAfter, dayRowCount: dayCountAfter } =
        await getRowCounts();
      expect(periodCountAfter).toEqual(periodCountBefore - 1);
      expect(dayCountAfter).toEqual(dayCountBefore - 1);
    });
  });
});
