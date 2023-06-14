/* eslint-disable no-underscore-dangle */
import { randomUUID } from 'crypto';
import { VehicleJourney, VehicleService, VehicleServiceBlock } from 'generic/timetablesdb/datasets/types';
import { HslTimetablesDbTables } from 'hsl/timetablesdb/datasets/schema';
import { HslVehicleScheduleFrame } from 'hsl/timetablesdb/datasets/types';
import { cloneDeep } from 'lodash';

export type VehicleJourneyInput = Partial<VehicleJourney> & {
  // TODO
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
export type TimetablesDataset = {
  _vehicle_schedule_frame: VehicleScheduleFrameInput;
};


const assignId = (item: Record<string, any>, idField: string) => {
  if (!item[idField]) {
    return item;
  }

  return {
    ...item,
    [idField]: randomUUID(),
  };
};

const assignParentId = (item: Record<string, any>, parentIdField: string, parentId: UUID) => {
  if (item[parentIdField]) {
    throw new Error('Parent id field already assigned');
  }

  return {
    ...item,
    [parentIdField]: parentId,
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
    return assignParentId(child, parentIdField, item[parentIdField]);
  });
  result[pluralField] = result[pluralField].map(mapper);

  return result;
};

const processVehicleJourney = (vehicleJourney: VehicleJourneyInput) => {
  let result = vehicleJourney;

  const idField = 'vehicle_journey_id';
  result = assignId(vehicleJourney, idField);

  return result;
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
  const result = cloneDeep(input);

  const stuff = processVehicleScheduleFrame(result._vehicle_schedule_frame);
  console.log('stuff:', JSON.stringify(stuff, null, 2));

  return [];
  // return input;
};
