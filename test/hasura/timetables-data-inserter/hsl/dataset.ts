import { omit } from 'lodash';
import {
  GenericJourneyPatternRefOutput,
  processDatasetJourneyPatternRefs,
} from 'timetables-data-inserter/generic';
import { writeBuiltDatasetToFile } from 'timetables-data-inserter/utils';
import {
  processHslVehicleScheduleFrame,
  processSubstituteOperatingPeriod,
} from './models';
import {
  HslTimetablesDatasetInput,
  HslTimetablesDatasetOutput,
  HslVehicleScheduleFrameInput,
  SubstituteOperatingPeriodInput,
} from './types';

const processDatasetHslVehicleScheduleFrames = <
  T extends HslVehicleScheduleFrameInput,
>(
  vehicleScheduleFrames: Record<string, T>,
  datasetInput: HslTimetablesDatasetInput,
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
      processHslVehicleScheduleFrame(child, inputWithJourneyPatternRefs),
    ]),
  );

  return processedVehicleScheduleFrames;
};

const processSubstituteOperatingDayPeriods = (
  periods: Record<string, SubstituteOperatingPeriodInput>,
) => {
  const processedPeriods = Object.fromEntries(
    Object.values(periods).map((child, i) => [
      Object.keys(periods)[i],
      processSubstituteOperatingPeriod(child),
    ]),
  );

  return processedPeriods;
};

export const buildHslTimetablesDataset = (
  datasetInput: HslTimetablesDatasetInput,
): HslTimetablesDatasetOutput => {
  const processedJourneyPatternRefs = processDatasetJourneyPatternRefs(
    datasetInput._journey_pattern_refs ?? {},
  );

  const processedVehicleScheduleFrames = processDatasetHslVehicleScheduleFrames(
    datasetInput._vehicle_schedule_frames ?? {},
    datasetInput,
    processedJourneyPatternRefs,
  );

  const processedSubstituteOperatingPeriods =
    processSubstituteOperatingDayPeriods(
      datasetInput._substitute_operating_periods ?? {},
    );

  const builtDataset = {
    ...omit(
      datasetInput,
      '_journey_pattern_refs',
      '_vehicle_schedule_frames',
      '_substitute_operating_periods',
    ),
    _journey_pattern_refs: processedJourneyPatternRefs,
    _vehicle_schedule_frames: processedVehicleScheduleFrames,
    _substitute_operating_periods: processedSubstituteOperatingPeriods,
  };
  writeBuiltDatasetToFile(builtDataset);

  return builtDataset;
};
