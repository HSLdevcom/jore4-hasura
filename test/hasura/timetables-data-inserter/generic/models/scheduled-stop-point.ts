import {
  JourneyPatternRef,
  ScheduledStopInJourneyPatternRef,
} from 'generic/timetablesdb/datasets/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericScheduledStopInJourneyPatternRefInput,
  GenericScheduledStopInJourneyPatternRefOutput,
} from '../types';

const getScheduledStopPointDefaults = () => ({
  timing_place_label: null,
});

export const processGenericScheduledStopPoint = (
  stopPoint: GenericScheduledStopInJourneyPatternRefInput,
  parentJourneyPatternRef: Pick<JourneyPatternRef, 'journey_pattern_ref_id'>,
): GenericScheduledStopInJourneyPatternRefOutput => {
  const idField = 'scheduled_stop_point_in_journey_pattern_ref_id';
  const result = assignId(stopPoint, idField);

  return {
    ...getScheduledStopPointDefaults(),
    ...result,
    journey_pattern_ref_id: parentJourneyPatternRef.journey_pattern_ref_id,
  };
};

export const scheduledStopPointToDbFormat = (
  stopPoint: GenericScheduledStopInJourneyPatternRefOutput,
): ScheduledStopInJourneyPatternRef => {
  return stopPoint;
};
