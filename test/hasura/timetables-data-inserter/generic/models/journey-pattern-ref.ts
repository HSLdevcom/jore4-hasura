import { randomUUID } from 'crypto';
import { TypeOfLine } from 'generic/networkdb/datasets/types';
import { JourneyPatternRef } from 'generic/timetablesdb/datasets/types';
import { omit } from 'lodash';
import { DateTime } from 'luxon';
import { assignId } from 'timetables-data-inserter/utils';
import { JourneyPatternRefInput, JourneyPatternRefOutput } from '../types';
import { processScheduledStopPoint } from './scheduled-stop-point';

export const processJourneyPatternRef = (
  journeyPatternRef: JourneyPatternRefInput,
): JourneyPatternRefOutput => {
  const idField = 'journey_pattern_ref_id';
  const result = assignId(journeyPatternRef, idField);

  const stopPoints = (result._stop_points || []).map((child) =>
    processScheduledStopPoint(child, result),
  );

  return {
    journey_pattern_id: randomUUID(),
    type_of_line: TypeOfLine.StoppingBusService,
    observation_timestamp: DateTime.fromISO('2023-07-01T00:00:00+00:00'),
    snapshot_timestamp: DateTime.fromISO('2023-09-28T00:00:00+00:00'),
    ...result,
    _stop_points: stopPoints,
  };
};

export const journeyPatternRefToDbFormat = (
  journeyPatternRef: JourneyPatternRefOutput,
): JourneyPatternRef => {
  return omit(journeyPatternRef, '_stop_points');
};
