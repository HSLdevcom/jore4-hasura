/* eslint-disable no-underscore-dangle */
import { randomUUID } from 'crypto';
import {
  ScheduledStopInJourneyPatternRef,
  TimetabledPassingTime,
  VehicleJourney,
  VehicleService,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { HslVehicleScheduleFrame } from 'hsl/timetablesdb/datasets/types';
import { cloneDeep, omit } from 'lodash';
import { Duration } from 'luxon';

export type PassingTimeInput = Partial<TimetabledPassingTime> & {
  _scheduled_stop_point_label: string;
  arrival_time: string | null;
  departure_time: string | null;
};

export type VehicleJourneyInput = Partial<VehicleJourney> & {
  _journey_pattern_ref_name?: string; // Required for input, missing from output. TODO: split types.

  _passing_times: PassingTimeInput[];
};

export type VehicleServiceBlockInput = Partial<VehicleServiceBlock> & {
  _vehicle_journey?: any;
  _vehicle_journeys?: any[];
};

export type VehicleServiceInput = Partial<VehicleService> & {
  _block?: VehicleServiceBlockInput;
  _blocks?: VehicleServiceBlockInput[];
};

export type VehicleScheduleFrameInput = Partial<HslVehicleScheduleFrame> & {
  name?: string;
  _vehicle_service?: VehicleServiceInput;
  _vehicle_services?: VehicleServiceInput[];
};

export type JourneyPatternsByNameInput = Record<
  string,
  {
    journey_pattern_ref_id?: UUID;
    _stop_points: ScheduledStopInJourneyPatternRef[];
  }
>;

export type TimetablesDataset = {
  _vehicle_schedule_frame: VehicleScheduleFrameInput;
  _journey_patterns_by_name: JourneyPatternsByNameInput;
};

// TODO: some better approach than global variable.
let datasetInput: TimetablesDataset | null = null;

const assignId = <T, K extends keyof T>(item: T, idField: K): T => {
  if (!item[idField]) {
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
  singularField,
  pluralField = `${singularField}s`,
  mapper,
}: {
  item: any;
  parentIdField: string;
  singularField: string;
  pluralField?: string;
  mapper: (arg1: any) => any;
}) => {
  const result = item;

  // Normalize child relationship field.
  if (!result[pluralField]) {
    result[pluralField] = [];
  }
  if (result[singularField]) {
    result[pluralField].push(result[singularField]);
  }
  delete result[singularField];

  result[pluralField] = result[pluralField].map((child: any) => {
    return assignForeignKey(child, parentIdField, item[parentIdField]);
  });
  result[pluralField] = result[pluralField].map(mapper);

  return result;
};

const processVehicleJourney = (vehicleJourney: VehicleJourneyInput) => {
  let result = vehicleJourney;

  const idField = 'vehicle_journey_id';
  result = assignId(vehicleJourney, idField);
  const journeyPatternRefName =
    result._journey_pattern_ref_name || 'TODO: how to handle this';
  const journeyPatternRef =
    datasetInput!._journey_patterns_by_name[journeyPatternRefName];
  result = assignForeignKey(
    vehicleJourney,
    'journey_pattern_ref_id',
    journeyPatternRef.journey_pattern_ref_id as UUID,
  );
  delete result._journey_pattern_ref_name;

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
    _passing_times: processedPassingTimes,
  };
};

const processBlock = (block: VehicleServiceBlockInput) => {
  let result = block;

  const idField = 'block_id';
  result = assignId(block, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    singularField: '_vehicle_journey',
    mapper: processVehicleJourney,
  });

  return result;
};

const processVehicleService = (vehicleService: VehicleServiceInput) => {
  let result = vehicleService;

  const idField = 'vehicle_service_id';
  result = assignId(vehicleService, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    singularField: '_block',
    mapper: processBlock,
  });

  return result;
};

const processVehicleScheduleFrame = (
  vehicleScheduleFrame: VehicleScheduleFrameInput,
) => {
  let result = vehicleScheduleFrame;

  const idField = 'vehicle_schedule_frame_id';
  result = assignId(vehicleScheduleFrame, idField);

  result = processChildren({
    item: result,
    parentIdField: idField,
    singularField: '_vehicle_service',
    mapper: processVehicleService,
  });

  return result;
};

export const buildTimetablesTableData = (
  input: TimetablesDataset,
): TableData<HslTimetablesDbTables>[] => {
  datasetInput = input;
  const result = cloneDeep(input);

  const stuff = processVehicleScheduleFrame(result._vehicle_schedule_frame);
  console.log('stuff:', JSON.stringify(stuff, null, 2));

  return [];
  // return input;
};
