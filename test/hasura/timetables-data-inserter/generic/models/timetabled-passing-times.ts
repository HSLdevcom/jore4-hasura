import omit from 'lodash/omit';
import {
  TimetabledPassingTime,
  VehicleJourney,
} from 'generic/timetablesdb/datasets/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericTimetabledPassingTimeInput,
  GenericTimetabledPassingTimeOutput,
} from '../types';

const getTimetabledPassingTimeDefaults = () => ({
  arrival_time: null,
  departure_time: null,
});

export const processGenericTimetabledPassingTime = (
  passingTime: GenericTimetabledPassingTimeInput,
  parentVehicleJourney: Pick<VehicleJourney, 'vehicle_journey_id'>,
  matchingStopPointId: UUID,
): GenericTimetabledPassingTimeOutput => {
  const idField = 'timetabled_passing_time_id';
  const result = assignId(passingTime, idField);

  return {
    ...getTimetabledPassingTimeDefaults(),
    ...omit(result, '_scheduled_stop_point_label'),
    vehicle_journey_id: parentVehicleJourney.vehicle_journey_id,
    scheduled_stop_point_in_journey_pattern_ref_id: matchingStopPointId,
  };
};

export const timetabledPassingTimeToDbFormat = (
  passingTime: GenericTimetabledPassingTimeOutput,
): TimetabledPassingTime => {
  return omit(passingTime, '_scheduled_stop_point_label');
};
