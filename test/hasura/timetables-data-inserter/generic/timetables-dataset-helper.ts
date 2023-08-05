import { flattenGenericDataset } from './table-data';
import {
  GenericTimetablesDatasetOutput,
  VehicleJourneyOutput,
  VehicleServiceBlockOutput,
  VehicleServiceOutput,
} from './types';

/**
 * Check that there exists exactly one item with given label.
 * Not intended for broader used, only exported so this can be used from HSL schema version of this helper.
 *
 * @protected
 */
export const sanityCheckLabelGroupResult = (
  itemType: string,
  label: string,
  foundResults: unknown[] | undefined,
) => {
  if (!foundResults || !foundResults.length) {
    throw new Error(
      `No ${itemType} row found for label ${label}: does not exist in dataset.`,
    );
  }
  if (foundResults.length > 1) {
    throw new Error(
      `Multiple ${itemType} rows found for label ${label}: should not be used for assertions.`,
    );
  }
};

export const createTimetablesDatasetHelper = <
  T extends GenericTimetablesDatasetOutput,
>(
  builtDataset: T,
) => {
  const flattened = flattenGenericDataset(builtDataset);

  // TODO: could these be done with generics?..
  const vehicleServicesByLabel = flattened.vehicleScheduleFrames
    .flatMap((vsf) => Object.entries(vsf._vehicle_services))
    .reduce((result, [label, vss]) => {
      const labelGroup = result[label] || [];
      labelGroup.push(vss);
      return {
        ...result,
        [label]: labelGroup,
      };
    }, {} as Record<string, VehicleServiceOutput[]>);

  const blocksByLabel = flattened.vehicleServices
    .flatMap((vs) => Object.entries(vs._blocks))
    .reduce((result, [label, block]) => {
      const labelGroup = result[label] || [];
      labelGroup.push(block);
      return {
        ...result,
        [label]: labelGroup,
      };
    }, {} as Record<string, VehicleServiceBlockOutput[]>);

  const vehicleJourneysByLabel = flattened.blocks
    .flatMap((block) => Object.entries(block._vehicle_journeys))
    .reduce((result, [label, vj]) => {
      const labelGroup = result[label] || [];
      labelGroup.push(vj);
      return {
        ...result,
        [label]: labelGroup,
      };
    }, {} as Record<string, VehicleJourneyOutput[]>);

  return {
    ...builtDataset,
    getVehicleService(label: string): VehicleServiceOutput {
      const forLabel = vehicleServicesByLabel[label];
      sanityCheckLabelGroupResult('vehicle service', label, forLabel);
      return forLabel[0];
    },
    getBlock(label: string): VehicleServiceBlockOutput {
      const forLabel = blocksByLabel[label];
      sanityCheckLabelGroupResult('vehicle service', label, forLabel);
      return forLabel[0];
    },
    getVehicleJourney(label: string): VehicleJourneyOutput {
      const forLabel = vehicleJourneysByLabel[label];
      sanityCheckLabelGroupResult('vehicle service', label, forLabel);
      return forLabel[0];
    },
  };
};
