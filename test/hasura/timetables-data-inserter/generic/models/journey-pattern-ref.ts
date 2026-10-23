import omit from 'lodash/omit';
import { parseDateTime } from '@util/time';
import {
  JourneyPatternRef,
  RouteDirection,
  TypeOfLine,
} from 'generic/timetablesdb/datasets/types';
import { assignId } from 'timetables-data-inserter/utils';
import {
  GenericJourneyPatternRefInput,
  GenericJourneyPatternRefOutput,
} from '../types';
import { processGenericScheduledStopPoint } from './scheduled-stop-point';

const getJourneyPatternRefDefaults = () => ({
  journey_pattern_id: crypto.randomUUID(),
  type_of_line: TypeOfLine.StoppingBusService,
  observation_timestamp: parseDateTime('2023-07-01T00:00:00+00:00'),
  snapshot_timestamp: parseDateTime('2023-09-28T00:00:00+00:00'),
  route_label: 'DEFAULT_ROUTE_LABEL',
  route_direction: RouteDirection.Outbound,
  route_validity_start: Temporal.PlainDate.from('2023-06-01'),
  route_validity_end: Temporal.PlainDate.from('2051-01-01'),
});

export const processGenericJourneyPatternRef = (
  journeyPatternRef: GenericJourneyPatternRefInput,
): GenericJourneyPatternRefOutput => {
  const idField = 'journey_pattern_ref_id';
  const result = assignId(journeyPatternRef, idField);

  const stopPoints = (result._stop_points ?? []).map((child) =>
    processGenericScheduledStopPoint(child, result),
  );

  return {
    ...getJourneyPatternRefDefaults(),
    ...result,
    _stop_points: stopPoints,
  };
};

export const journeyPatternRefToDbFormat = (
  journeyPatternRef: GenericJourneyPatternRefOutput,
): JourneyPatternRef => {
  return omit(journeyPatternRef, '_stop_points');
};
