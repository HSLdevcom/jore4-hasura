import { scheduledStopPoints as genericScheduledStopPoints } from 'generic/networkdb/datasets/defaultSetup';
import { buildHslScheduledStopPoint } from '../factories';
import { HslScheduledStopPoint } from '../types';

export const hslScheduledStopPoints: HslScheduledStopPoint[] =
  genericScheduledStopPoints.map((r) => buildHslScheduledStopPoint(r));
