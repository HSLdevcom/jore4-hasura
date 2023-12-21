import {
  JourneyPatternRef,
  RouteDirection,
  TypeOfLine,
} from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { DateTime } from 'luxon';
import { assignId } from 'timetables-data-inserter/utils';
import { v4 as uuidv4 } from 'uuid';
import {
  GenericJourneyPatternRefInput,
  GenericJourneyPatternRefOutput,
} from '../types';
import { processGenericScheduledStopPoint } from './scheduled-stop-point';

const getJourneyPatternRefDefaults = () => ({
  journey_pattern_id: uuidv4(),
  type_of_line: TypeOfLine.StoppingBusService,
  observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
  snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
  route_label: 'DEFAULT_ROUTE_LABEL',
  route_direction: RouteDirection.Outbound,
  route_validity_start: DateTime.fromISO('2023-06-01T00:00:00+00:00'),
  route_validity_end: DateTime.fromISO('2051-01-01T00:00:00+00:00'),
});

export const processGenericJourneyPatternRef = (
  journeyPatternRef: GenericJourneyPatternRefInput,
): GenericJourneyPatternRefOutput => {
  const idField = 'journey_pattern_ref_id';
  const result = assignId(journeyPatternRef, idField);

  const stopPoints = (result._stop_points || []).map((child) =>
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
