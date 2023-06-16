/* eslint-disable no-underscore-dangle */
import { serializeInsertInput } from '@util/dataset';
import { buildInsertQuery } from '@util/db';
import { randomUUID } from 'crypto';
import { defaultDayTypeIds } from 'generic/timetablesdb/datasets/defaultSetup/day-types';
import { EntityName, buildName } from 'generic/timetablesdb/datasets/factories';
import {
  JourneyPatternRef,
  ScheduledStopInJourneyPatternRef,
  TimetablePriority,
  TimetabledPassingTime,
  VehicleJourney,
  VehicleService,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';
import { isFileDataSource } from 'hsl/networkdb/datasets/types';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { HslVehicleScheduleFrame } from 'hsl/timetablesdb/datasets/types';
import { cloneDeep, merge, omit } from 'lodash';
import { Duration } from 'luxon';

// TODO:
// - split to smaller files
// - have separate typings for input and output
// - take input as plain JSON
// - include method for inserting straight to DB (so we don't need to duplicate the db utils)

export type TimetabledPassingTimeInput = Partial<
  Omit<TimetabledPassingTime, 'arrival_time' | 'departure_time'>
> & {
  _scheduled_stop_point_label: string;
  arrival_time: string | null;
  departure_time: string | null;
};

export type VehicleJourneyInput = Partial<VehicleJourney> & {
  _journey_pattern_ref_name?: string; // Required for input, missing from output. TODO: split types.

  _passing_times: TimetabledPassingTimeInput[];
};

export type VehicleServiceBlockInput = Partial<VehicleServiceBlock> & {
  _vehicle_journeys?: VehicleJourneyInput[];
};

export type VehicleServiceInput = Partial<VehicleService> & {
  day_type_id?: keyof typeof defaultDayTypeIds;
  _blocks?: VehicleServiceBlockInput[];
};

export type VehicleScheduleFrameInput = Partial<
  Omit<
    HslVehicleScheduleFrame,
    'validity_start' | 'validity_end' | 'created_at' | 'priority'
  >
> & {
  name_i18n?: LocalizedString; // TODO: this should already come from HslVehicleScheduleFrame via VehicleScheduleFrame
  validity_start: string;
  validity_end: string;
  priority?: TimetablePriority | keyof typeof TimetablePriority;
  created_at?: string;
  name?: string;
  _vehicle_service?: VehicleServiceInput;
  _vehicle_services?: VehicleServiceInput[];
} & EntityName;

export type ScheduledStopInJourneyPatternRefInput =
  Partial<ScheduledStopInJourneyPatternRef>;

export type JourneyPatternRefInput = {
  journey_pattern_ref_id?: UUID;
  _stop_points: ScheduledStopInJourneyPatternRefInput[];
};

export type JourneyPatternsRefsByNameInput = Record<
  string,
  JourneyPatternRefInput
>;

export type TimetablesDataset = {
  _vehicle_schedule_frames?: VehicleScheduleFrameInput[];
  _journey_pattern_refs_by_name?: JourneyPatternsRefsByNameInput;
};

// TODO: some better approach than global variable.
let datasetInput: TimetablesDataset | null = null;

const assignId = <T, K extends keyof T>(item: T, idField: K): T => {
  if (item[idField]) {
    return item;
  }

  return {
    ...item,
    [idField]: randomUUID() as T[K],
  };
};

const assignForeignKey = <T, K extends keyof T>(
  item: T,
  fieldName: K,
  id: UUID,
): T => {
  if (item[fieldName]) {
    throw new Error(`Foreign key ${fieldName.toString()} already assigned`);
  }

  return {
    ...item,
    [fieldName]: id as T[K],
  };
};

const processChildren = ({
  item,
  parentIdField,
  childField,
  mapper,
}: {
  item: any;
  parentIdField: string;
  childField: string;
  mapper: (arg1: any) => any;
}) => {
  const result = item;

  result[childField] = result[childField].map((child: any) => {
    return assignForeignKey(child, parentIdField, item[parentIdField]);
  });
  result[childField] = result[childField].map(mapper);

  return result;
};

const processVehicleJourney = (vehicleJourney: VehicleJourneyInput) => {
  let result = vehicleJourney;

  const idField = 'vehicle_journey_id';
  result = assignId(result, idField);
  const journeyPatternRefName =
    result._journey_pattern_ref_name || 'TODO: how to handle this';
  const journeyPatternRef =
    datasetInput!._journey_pattern_refs_by_name![journeyPatternRefName];
  result = assignForeignKey(
    vehicleJourney,
    'journey_pattern_ref_id',
    journeyPatternRef.journey_pattern_ref_id as UUID,
  );

  const stopPoints = journeyPatternRef._stop_points;
  const processedPassingTimes = result._passing_times.map((pt) => {
    const matchingStopPoint = stopPoints.find(
      (sp) => sp.scheduled_stop_point_label === pt._scheduled_stop_point_label,
    );

    return {
      ...omit(pt, ['_scheduled_stop_point_label']),
      vehicle_journey_id: result.vehicle_journey_id,
      scheduled_stop_point_in_journey_pattern_ref_id:
        matchingStopPoint!.scheduled_stop_point_in_journey_pattern_ref_id,
      arrival_time: pt.arrival_time
        ? Duration.fromISO(pt.arrival_time)
        : pt.arrival_time,
      departure_time: pt.departure_time
        ? Duration.fromISO(pt.departure_time)
        : pt.departure_time,
    };
  });

  return {
    ...result,
    _passing_times: processedPassingTimes,
  };
};

const vehicleJourneyToDbFormat = (
  vehicleJourney: VehicleJourneyInput,
): VehicleJourney => {
  // TODO: add defaults for all values and remove type cast.
  return omit(vehicleJourney, [
    '_journey_pattern_ref_name',
    '_passing_times',
  ]) as VehicleJourney;
};

const timetabledPassingTimeToDbFormat = (
  passingTime: TimetabledPassingTimeInput,
): TimetabledPassingTime => {
  // TODO: add defaults for all values and remove type cast.
  return omit(passingTime, [
    '_scheduled_stop_point_label',
  ]) as TimetabledPassingTime;
};

const processBlock = (block: VehicleServiceBlockInput) => {
  let result = block;

  const idField = 'block_id';
  result = assignId(result, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    childField: '_vehicle_journeys',
    mapper: processVehicleJourney,
  });

  return result;
};

const vehicleServiceBlockToDbFormat = (
  block: VehicleServiceBlockInput,
): VehicleServiceBlock => {
  // TODO: add defaults for all values and remove type cast.
  return omit(block, ['_vehicle_journeys']) as VehicleServiceBlock;
};

const processVehicleService = (vehicleService: VehicleServiceInput) => {
  let result = vehicleService;

  const idField = 'vehicle_service_id';
  result = assignId(result, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    childField: '_blocks',
    mapper: processBlock,
  });

  return {
    ...result,
    day_type_id: defaultDayTypeIds[result.day_type_id || 'MONDAY_FRIDAY'],
  };
};

const vehicleServiceToDbFormat = (
  vehicleService: VehicleServiceInput,
): VehicleService => {
  // TODO: add defaults for all values and remove type cast.
  return omit(vehicleService, ['_blocks']) as VehicleService;
};

const processVehicleScheduleFrame = (
  vehicleScheduleFrame: VehicleScheduleFrameInput,
): RequiredKeys<Omit<VehicleScheduleFrameInput, 'name'>, 'name_i18n'> => {
  let result = vehicleScheduleFrame;

  const idField = 'vehicle_schedule_frame_id';
  result = assignId(result, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    childField: '_vehicle_services',
    mapper: processVehicleService,
  });

  return {
    label: buildName(result).fi_FI,
    name_i18n: buildName(result),
    ...result,
    priority: TimetablePriority[
      result.priority || 'Standard'
    ] as TimetablePriority,
  };
};

const vehicleScheduleFrameToDbFormat = (
  vehicleScheduleFrame: VehicleScheduleFrameInput,
): HslVehicleScheduleFrame => {
  // TODO: add defaults for all values and remove type cast.
  // TODO: fix types and remove the "unknown" cast. That is required at the moment because DateTime types don't match
  return omit(vehicleScheduleFrame, [
    'name',
    '_vehicle_services',
  ]) as unknown as HslVehicleScheduleFrame;
};

const processScheduledStopPoint = (
  stopPoint: ScheduledStopInJourneyPatternRefInput,
) => {
  let result = stopPoint;

  const idField = 'scheduled_stop_point_in_journey_pattern_ref_id';
  result = assignId(result, idField);

  return result;
};

const scheduledStopPointToDbFormat = (
  stopPoint: ScheduledStopInJourneyPatternRefInput,
): ScheduledStopInJourneyPatternRef => {
  // TODO: fix typings so the type cast is not required. All properties are assigned at this point.
  return stopPoint as ScheduledStopInJourneyPatternRef;
};

const processJourneyPatternRef = (
  journeyPatternRef: JourneyPatternRefInput,
) => {
  let result = journeyPatternRef;

  const idField = 'journey_pattern_ref_id';
  result = assignId(result, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    childField: '_stop_points',
    mapper: processScheduledStopPoint,
  });

  return result;
};

const journeyPatternRefToDbFormat = (
  journeyPatternRef: JourneyPatternRefInput,
): JourneyPatternRef => {
  // TODO: add defaults for all values and remove type cast.
  return omit(journeyPatternRef, ['_stop_points']) as JourneyPatternRef;
};

const flattenDataset = (dataset: TimetablesDataset) => {
  const flattened = {
    vehicleScheduleFrames: [] as VehicleScheduleFrameInput[],
    vehicleServices: [] as VehicleServiceInput[],
    blocks: [] as VehicleServiceBlockInput[],
    vehicleJourneys: [] as VehicleJourneyInput[],
    passingTimes: [] as TimetabledPassingTimeInput[],
    journeyPatternRefs: [] as JourneyPatternRefInput[],
    stopPoints: [] as ScheduledStopInJourneyPatternRefInput[],
  };

  flattened.vehicleScheduleFrames.push(
    ...(dataset._vehicle_schedule_frames || []),
  );
  flattened.vehicleServices.push(
    ...flattened.vehicleScheduleFrames
      .map((vsf) => vsf._vehicle_services || [])
      .flat(),
  );
  flattened.blocks.push(
    ...flattened.vehicleServices.map((vsf) => vsf._blocks || []).flat(),
  );
  flattened.vehicleJourneys.push(
    ...flattened.blocks.map((vsf) => vsf._vehicle_journeys || []).flat(),
  );
  flattened.passingTimes.push(
    ...flattened.vehicleJourneys.map((vsf) => vsf._passing_times || []).flat(),
  );

  flattened.journeyPatternRefs.push(
    ...Object.values(dataset._journey_pattern_refs_by_name || {}),
  );
  flattened.stopPoints.push(
    ...flattened.journeyPatternRefs.map((jpr) => jpr._stop_points).flat(),
  );

  return flattened;
};

export const createTableData = (
  builtDataset: TimetablesDataset,
): TableData<HslTimetablesDbTables>[] => {
  const flattenedDataset = flattenDataset(builtDataset);

  const tableData: TableData<HslTimetablesDbTables>[] = [
    {
      name: 'vehicle_schedule.vehicle_schedule_frame',
      data: flattenedDataset.vehicleScheduleFrames.map(
        vehicleScheduleFrameToDbFormat,
      ),
    },
    {
      name: 'vehicle_service.vehicle_service',
      data: flattenedDataset.vehicleServices.map(vehicleServiceToDbFormat),
    },
    {
      name: 'vehicle_service.block',
      data: flattenedDataset.blocks.map(vehicleServiceBlockToDbFormat),
    },
    {
      name: 'journey_pattern.journey_pattern_ref',
      data: flattenedDataset.journeyPatternRefs.map(
        journeyPatternRefToDbFormat,
      ),
    },
    {
      name: 'service_pattern.scheduled_stop_point_in_journey_pattern_ref',
      data: flattenedDataset.stopPoints.map(scheduledStopPointToDbFormat),
    },
    {
      name: 'vehicle_journey.vehicle_journey',
      data: flattenedDataset.vehicleJourneys.map(vehicleJourneyToDbFormat),
    },
    {
      name: 'passing_times.timetabled_passing_time',
      data: flattenedDataset.passingTimes.map(timetabledPassingTimeToDbFormat),
    },
    // TODO: 'service_calendar.substitute_operating_day_by_line_type'
  ];

  return tableData;
};

// TODO: quite some overlap here with insertTableData in test/hasura/util/setup.ts, maybe some opportunities for refactoring.
export const tableDataToSql = (
  tableData: TableData<HslTimetablesDbTables>[],
): string => {
  const insertsForTables = tableData.map((td) => {
    const { data } = td;
    if (isFileDataSource(data)) {
      throw new Error('Data file sources not supported');
    }

    const serializedData = data.map(serializeInsertInput);
    const insertSql = buildInsertQuery(td.name, serializedData).toString();
    return `${insertSql};`; // Semicolon not included by default, terminate the statement.
  });

  return insertsForTables.join('\n\n'); // For clarity.
};

const mergeTimetablesDatasets = (
  datasets: TimetablesDataset[],
): TimetablesDataset => {
  // TODO: better implementation. _.merge merges arrays by index, so is not ideal here.
  return merge({}, ...datasets);
};

export const buildTimetablesDataset = (
  inputs: TimetablesDataset | TimetablesDataset[],
): TimetablesDataset => {
  datasetInput = Array.isArray(inputs)
    ? mergeTimetablesDatasets(inputs)
    : inputs;

  const result = cloneDeep(datasetInput);

  const processedJprs: JourneyPatternsRefsByNameInput = {};
  Object.entries(result._journey_pattern_refs_by_name || {}).forEach(
    ([jprName, jpr]) => {
      processedJprs[jprName] = processJourneyPatternRef(jpr);
    },
  );
  result._journey_pattern_refs_by_name = processedJprs;
  // TODO: fix hackety hack. This is needed because VSF processing needs JPR ids present in the input.
  datasetInput._journey_pattern_refs_by_name =
    result._journey_pattern_refs_by_name;

  result._vehicle_schedule_frames = result._vehicle_schedule_frames?.map(
    processVehicleScheduleFrame,
  );

  // TODO: use different return type to show that all properties are assigned.
  return result;
};
