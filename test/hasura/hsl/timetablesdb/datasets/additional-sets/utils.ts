import { mergeLists } from '@util/schema';
import { defaultHslTimetablesDbData } from '../defaultSetup';
import { HslTimetablesDbTables } from '../schema';

/**
 * Gets the default timetable db data with given additions. Currently the this extends the default
 * dataset with
 * * Timetable dataset (which consists of vehicle_schedule_frames, vehicle_services,
 *   vehicleServiceBlocks and vehicleJourneys, NOTE: when needed, this can be modified to also take in
 *   passing_times)
 * * Substitute operating day by line type datasets (which consists of substitute_operating_day_by_line_type )
 *
 * New additional datasets can be added to 'datasets/additional-sets'
 */
export const getDbDataWithAdditionalDatasets = ({
  dbData = defaultHslTimetablesDbData,
  datasets = [],
}: // substituteOperatingDayByLineTypeDatasets = [],
{
  dbData?: TableData<HslTimetablesDbTables>[];
  datasets?: TableData<HslTimetablesDbTables>[][];
}) => {
  const getDataByKey = (
    data: TableData<HslTimetablesDbTables>[],
    key: HslTimetablesDbTables,
  ) => {
    const dataByKey = data.find((item) => item.name === key);
    return dataByKey ? dataByKey.data : [];
  };

  const getCombinedData = (
    data: TableData<HslTimetablesDbTables>[][],
    key: HslTimetablesDbTables,
  ): TableData<HslTimetablesDbTables> => ({
    name: key,
    data: [
      ...Object.values(getDataByKey(dbData, key)),
      // For some reason flatMap() is not acceptable to typescript linter, so need to do .map().flat(1)..
      ...data.map((item) => getDataByKey(item, key)).flat(1),
    ],
  });

  const testData: TableData<HslTimetablesDbTables>[] = [
    ...mergeLists(
      dbData,
      [
        getCombinedData(datasets, 'vehicle_schedule.vehicle_schedule_frame'),
        getCombinedData(datasets, 'vehicle_service.vehicle_service'),
        getCombinedData(datasets, 'vehicle_service.block'),
        getCombinedData(datasets, 'vehicle_journey.vehicle_journey'),
        getCombinedData(
          datasets,
          'service_calendar.substitute_operating_day_by_line_type',
        ),
        getCombinedData(
          datasets,
          'service_calendar.substitute_operating_period',
        ),
      ],
      (tableSchema) => tableSchema.name,
    ),
  ];
  return testData;
};
