import { VehicleService } from 'generic/timetablesdb/datasets/types';
import { processGenericBlock } from 'timetables-data-inserter/generic';
import {
  HslTimetablesDatasetInput,
  HslVehicleServiceBlockInput,
  HslVehicleServiceBlockOutput,
} from '../types';
import { processHslVehicleJourney } from './vehicle-journey';

const getBlockDefaults = () => ({});

export const processHslBlock = (
  block: HslVehicleServiceBlockInput,
  parentVehicleService: Pick<VehicleService, 'vehicle_service_id'>,
  datasetInput: HslTimetablesDatasetInput,
): HslVehicleServiceBlockOutput => {
  const genericBlock = processGenericBlock(
    block,
    parentVehicleService,
    datasetInput,
  );
  const result = genericBlock;

  const vehicleJourneys = block._vehicle_journeys ?? {};
  const processedVehicleJourneys = Object.fromEntries(
    Object.values(vehicleJourneys).map((child, i) => [
      Object.keys(vehicleJourneys)[i],
      processHslVehicleJourney(child, result, datasetInput),
    ]),
  );

  return {
    ...getBlockDefaults(),
    ...result,
    _vehicle_journeys: processedVehicleJourneys,
  };
};
