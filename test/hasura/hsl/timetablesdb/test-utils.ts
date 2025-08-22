import { sortBy } from 'lodash';
import { TimetablePriority } from 'generic/timetablesdb/datasets/types';
import { TimetableVersion, VehicleSchedule } from './datasets/types';

/**
 * This function can be used to sort the response and the expected result lists in to
 * the same order, so we can ignore the order of the response and developer doesn't need
 * to care in what order the response list comes in.
 *
 * Example use:
 * expect(sortVersionsForAssert(response)).toEqual(sortVersionsForAssert(expectedResult));
 */
export const sortVersionsForAssert = (
  data: {
    vehicle_schedule_frame_id: UUID | null;
    day_type_id: UUID;
    in_effect: boolean;
    substitute_operating_day_by_line_type_id: UUID | null;
  }[],
) =>
  sortBy(data, [
    'vehicle_schedule_frame_id',
    'day_type_id',
    'in_effect',
    'substitute_operating_day_by_line_type_id',
  ]);

/**
 * Extracts and maps only the test relevant information from the response.
 */
export const mapTimetableVersionResponse = (response: TimetableVersion[]) =>
  response.map((version) => ({
    vehicle_schedule_frame_id: version.vehicle_schedule_frame_id,
    substitute_operating_day_by_line_type_id:
      version.substitute_operating_day_by_line_type_id,
    day_type_id: version.day_type_id,
    in_effect: version.in_effect,
  }));

/**
 * Extracts and maps only the test relevant information from the response
 */
export const mapVehicleScheduleResponse = (response: VehicleSchedule[]) =>
  response.map((vehicleSchedule) => ({
    vehicle_journey_id: vehicleSchedule.vehicle_journey_id,
    vehicle_schedule_frame_id: vehicleSchedule.vehicle_schedule_frame_id,
    substitute_operating_day_by_line_type_id:
      vehicleSchedule.substitute_operating_day_by_line_type_id,
    day_type_id: vehicleSchedule.day_type_id,
    priority: vehicleSchedule.priority,
  }));

/**
 * This function can be used to sort the response and the expected result lists in to
 * the same order, so we can ignore the order of the response and developer doesn't need
 * to care in what order the response list comes in.
 *
 * Example use:
 * expect(sortVehicleSchedulesForAssert(response)).toEqual(sortVehicleSchedulesForAssert(expectedResult));
 */
export const sortVehicleSchedulesForAssert = (
  data: {
    vehicle_journey_id: UUID | null;
    vehicle_schedule_frame_id: UUID | null;
    substitute_operating_day_by_line_type_id: UUID | null;
    day_type_id: UUID;
    priority: TimetablePriority;
  }[],
) =>
  sortBy(data, [
    'day_type_id',
    'substitute_operating_day_by_line_type_id',
    'vehicle_schedule_frame_id',
    'vehicle_journey_id',
    'priority',
  ]);
