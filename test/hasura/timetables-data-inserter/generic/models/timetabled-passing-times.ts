import {
  TimetabledPassingTime,
  VehicleJourney,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { assignId } from 'timetables-data-inserter/utils';
import {
  TimetabledPassingTimeInput,
  TimetabledPassingTimeOutput,
} from '../types';

const getTimetabledPassingTimeDefaults = () => ({
  arrival_time: null,
  departure_time: null,
});

export const processTimetabledPassingTime = (
  passingTime: TimetabledPassingTimeInput,
  parentVehicleJourney: Pick<VehicleJourney, 'vehicle_journey_id'>,
  matchingStopPointId: UUID,
): TimetabledPassingTimeOutput => {
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
  passingTime: TimetabledPassingTimeOutput,
): TimetabledPassingTime => {
  return omit(passingTime, '_scheduled_stop_point_label');
};
