import omit from 'lodash/omit';
import {
  VehicleService,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericVehicleServiceBlockInput,
  GenericVehicleServiceBlockOutput,
} from '../types';
import { processGenericVehicleJourney } from './vehicle-journey';

const getBlockDefaults = () => ({
  preparing_time: null,
  finishing_time: null,
});

export const processGenericBlock = (
  block: GenericVehicleServiceBlockInput,
  parentVehicleService: Pick<VehicleService, 'vehicle_service_id'>,
  datasetInput: TimetablesDatasetInput,
): GenericVehicleServiceBlockOutput => {
  const idField = 'block_id';
  const result = assignId(block, idField);

  const vehicleJourneys = result._vehicle_journeys ?? {};
  const processedVehicleJourneys = Object.fromEntries(
    Object.values(vehicleJourneys).map((child, i) => [
      Object.keys(vehicleJourneys)[i],
      processGenericVehicleJourney(child, result, datasetInput),
    ]),
  );

  return {
    ...getBlockDefaults(),
    ...result,
    vehicle_service_id: parentVehicleService.vehicle_service_id,
    _vehicle_journeys: processedVehicleJourneys,
  };
};

export const vehicleServiceBlockToDbFormat = (
  block: GenericVehicleServiceBlockOutput,
): VehicleServiceBlock => {
  return omit(block, '_vehicle_journeys');
};
