import {
  JourneyPatternRef,
  ScheduledStopInJourneyPatternRef,
} from 'generic/timetablesdb/datasets/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  ScheduledStopInJourneyPatternRefInput,
  ScheduledStopInJourneyPatternRefOutput,
} from '../types';

export const processScheduledStopPoint = (
  stopPoint: ScheduledStopInJourneyPatternRefInput,
  parentJourneyPatternRef: Pick<JourneyPatternRef, 'journey_pattern_ref_id'>,
): ScheduledStopInJourneyPatternRefOutput => {
  const idField = 'scheduled_stop_point_in_journey_pattern_ref_id';
  const result = assignId(stopPoint, idField);

  return {
    ...result,
    journey_pattern_ref_id: parentJourneyPatternRef.journey_pattern_ref_id,
  };
};

export const scheduledStopPointToDbFormat = (
  stopPoint: ScheduledStopInJourneyPatternRefOutput,
): ScheduledStopInJourneyPatternRef => {
  return stopPoint;
};
