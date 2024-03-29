import {
  VehicleJourney,
  VehicleServiceBlock,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { TimetablesDatasetInput } from 'timetables-data-inserter/types';
import { assignForeignKey, assignId } from 'timetables-data-inserter/utils';
import {
  GenericVehicleJourneyInput,
  GenericVehicleJourneyOutput,
} from '../types';
import { processGenericTimetabledPassingTime } from './timetabled-passing-times';

const getVehicleJourneyDefaults = () => ({
  turnaround_time: null,
  layover_time: null,
});

export const processGenericVehicleJourney = (
  vehicleJourney: GenericVehicleJourneyInput,
  parentBlock: Pick<VehicleServiceBlock, 'block_id'>,
  datasetInput: TimetablesDatasetInput,
): GenericVehicleJourneyOutput => {
  const idField = 'vehicle_journey_id';
  const vjWithId = assignId(vehicleJourney, idField);

  if (!datasetInput._journey_pattern_refs) {
    throw new Error('_journey_pattern_refs not set');
  }
  const journeyPatternRefName = vjWithId._journey_pattern_ref_name;
  const journeyPatternRef =
    datasetInput._journey_pattern_refs[journeyPatternRefName];
  if (!journeyPatternRef) {
    throw new Error(
      `Could not find journey_pattern_ref with name ${journeyPatternRefName}`,
    );
  }

  const result = assignForeignKey(
    vjWithId,
    'journey_pattern_ref_id',
    journeyPatternRef.journey_pattern_ref_id as UUID,
  );

  const stopPoints = journeyPatternRef._stop_points || [];
  const passingTimes = result._passing_times || [];
  const processedPassingTimes = passingTimes.map((pt) => {
    const matchingStopPoint = stopPoints.find(
      (sp) => sp.scheduled_stop_point_label === pt._scheduled_stop_point_label,
    );
    if (!matchingStopPoint) {
      throw new Error(
        `Stop point with label ${pt._scheduled_stop_point_label} not found.`,
      );
    }
    if (!matchingStopPoint.scheduled_stop_point_in_journey_pattern_ref_id) {
      throw new Error(
        `Stop point with label ${pt._scheduled_stop_point_label} is missing an id.`,
      );
    }

    return processGenericTimetabledPassingTime(
      pt,
      result,
      matchingStopPoint.scheduled_stop_point_in_journey_pattern_ref_id,
    );
  });

  return {
    ...getVehicleJourneyDefaults(),
    ...result,
    block_id: parentBlock.block_id,
    _passing_times: processedPassingTimes,
  };
};

export const vehicleJourneyToDbFormat = (
  vehicleJourney: GenericVehicleJourneyOutput,
): VehicleJourney => {
  return omit(vehicleJourney, '_journey_pattern_ref_name', '_passing_times');
};
