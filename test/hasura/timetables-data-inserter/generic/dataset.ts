import isArray from 'lodash/isArray';
import mergeWith from 'lodash/mergeWith';
import omit from 'lodash/omit';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { writeBuiltDatasetToFile } from 'timetables-data-inserter/utils';
import {
  processGenericJourneyPatternRef,
  processGenericVehicleScheduleFrame,
} from './models';
import {
  GenericJourneyPatternRefInput,
  GenericJourneyPatternRefOutput,
  GenericTimetablesDatasetInput,
  GenericTimetablesDatasetOutput,
  GenericVehicleScheduleFrameInput,
} from './types';

export const processDatasetJourneyPatternRefs = <
  T extends GenericJourneyPatternRefInput,
>(
  journeyPatternRefsByName: Record<string, T>,
) => {
  return Object.fromEntries(
    Object.values(journeyPatternRefsByName).map((child, i) => [
      Object.keys(journeyPatternRefsByName)[i],
      processGenericJourneyPatternRef(child),
    ]),
  );
};

export const processDatasetGenericVehicleScheduleFrames = <
  T extends GenericVehicleScheduleFrameInput,
>(
  vehicleScheduleFrames: Record<string, T>,
  datasetInput: GenericTimetablesDatasetInput,
  processedJourneyPatternRefs: Record<string, GenericJourneyPatternRefOutput>,
) => {
  // Ids for JPRs are required during VSF processing.
  const inputWithJourneyPatternRefs = {
    ...datasetInput,
    _journey_pattern_refs: processedJourneyPatternRefs,
  };

  const processedVehicleScheduleFrames = Object.fromEntries(
    Object.values(vehicleScheduleFrames).map((child, i) => [
      Object.keys(vehicleScheduleFrames)[i],
      processGenericVehicleScheduleFrame(child, inputWithJourneyPatternRefs),
    ]),
  );

  return processedVehicleScheduleFrames;
};

export const mergeTimetablesDatasets = <T extends TimetablesDatasetInput>(
  datasets: T[],
): T => {
  return mergeWith({}, ...datasets, (objValue: unknown, srcValue: unknown) => {
    if (isArray(objValue)) {
      // Normally lodash merges arrays by index.
      // For our purposes it might be better to replace whole array.
      return srcValue;
    }
    return undefined;
  });
};

export const buildGenericTimetablesDataset = (
  datasetInput: GenericTimetablesDatasetInput,
): GenericTimetablesDatasetOutput => {
  const processedJourneyPatternRefs = processDatasetJourneyPatternRefs(
    datasetInput._journey_pattern_refs ?? {},
  );

  const processedVehicleScheduleFrames =
    processDatasetGenericVehicleScheduleFrames(
      datasetInput._vehicle_schedule_frames ?? {},
      datasetInput,
      processedJourneyPatternRefs,
    );

  const builtDataset = {
    // Currently this omit returns an empty object, but it still allows TS to
    // infer keys of _vehicle_schedule_frames etc objects in return value
    // (even if autocomplete for this does not necessarily work in IDE).
    ...omit(datasetInput, '_journey_pattern_refs', '_vehicle_schedule_frames'),
    _journey_pattern_refs: processedJourneyPatternRefs,
    _vehicle_schedule_frames: processedVehicleScheduleFrames,
  };
  writeBuiltDatasetToFile(builtDataset);

  return builtDataset;
};
