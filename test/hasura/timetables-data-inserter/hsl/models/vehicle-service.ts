import { HslVehicleScheduleFrame } from 'hsl/timetablesdb/datasets/types';
import { processGenericVehicleService } from 'timetables-data-inserter/generic';
import {
  HslTimetablesDatasetInput,
  HslVehicleServiceInput,
  HslVehicleServiceOutput,
} from '../types';
import { processHslBlock } from './block';

const getVehicleServiceDefaults = () => ({});

export const processHslVehicleService = (
  vehicleService: HslVehicleServiceInput,
  parentVehicleScheduleFrame: Pick<
    HslVehicleScheduleFrame,
    'vehicle_schedule_frame_id'
  >,
  datasetInput: HslTimetablesDatasetInput,
): HslVehicleServiceOutput => {
  const genericVehicleService = processGenericVehicleService(
    vehicleService,
    parentVehicleScheduleFrame,
    datasetInput,
  );
  const result = genericVehicleService;

  const blocks = vehicleService._blocks || {};
  const processedBlocks = Object.fromEntries(
    Object.values(blocks).map((child, i) => [
      Object.keys(blocks)[i],
      processHslBlock(child, result, datasetInput),
    ]),
  );

  return {
    ...getVehicleServiceDefaults(),
    ...result,
    _blocks: processedBlocks,
  };
};
