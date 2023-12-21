import { VehicleServiceBlock } from 'generic/timetablesdb/datasets/types';
import { processGenericVehicleJourney } from 'timetables-data-inserter/generic';
import {
  HslTimetablesDatasetInput,
  HslVehicleJourneyInput,
  HslVehicleJourneyOutput,
} from '../types';

const getVehicleJourneyDefaults = () => ({});

export const processHslVehicleJourney = (
  vehicleJourney: HslVehicleJourneyInput,
  parentBlock: Pick<VehicleServiceBlock, 'block_id'>,
  datasetInput: HslTimetablesDatasetInput,
): HslVehicleJourneyOutput => {
  const genericJourney = processGenericVehicleJourney(
    vehicleJourney,
    parentBlock,
    datasetInput,
  );
  const result = genericJourney;

  return {
    ...getVehicleJourneyDefaults(),
    ...result,
  };
};
