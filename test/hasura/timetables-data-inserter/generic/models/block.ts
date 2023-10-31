import {
  VehicleService,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { assignId } from 'timetables-data-inserter/utils';
import { VehicleServiceBlockInput, VehicleServiceBlockOutput } from '../types';
import { processVehicleJourney } from './vehicle-journey';

export const processBlock = (
  block: VehicleServiceBlockInput,
  parentVehicleService: Pick<VehicleService, 'vehicle_service_id'>,
  datasetInput: TimetablesDatasetInput,
): VehicleServiceBlockOutput => {
  const idField = 'block_id';
  const result = assignId(block, idField);

  const vehicleJourneys = result._vehicle_journeys || {};
  const processedVehicleJourneys = Object.fromEntries(
    Object.values(vehicleJourneys).map((child, i) => [
      Object.keys(vehicleJourneys)[i],
      processVehicleJourney(child, result, datasetInput),
    ]),
  );

  return {
    preparing_time: null,
    finishing_time: null,
    ...result,
    vehicle_service_id: parentVehicleService.vehicle_service_id,
    _vehicle_journeys: processedVehicleJourneys,
  };
};

export const vehicleServiceBlockToDbFormat = (
  block: VehicleServiceBlockOutput,
): VehicleServiceBlock => {
  return omit(block, '_vehicle_journeys');
};
