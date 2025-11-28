import {
  scheduledStopPointInvariants,
  scheduledStopPoints as genericScheduledStopPoints,
  vehicleModeOnScheduledStopPoint,
} from 'generic/networkdb/datasets/defaultSetup';
import { buildHslScheduledStopPoint } from '../factories';
import { HslScheduledStopPoint } from '../types';

export const hslScheduledStopPoints: HslScheduledStopPoint[] =
  genericScheduledStopPoints.map((r) => buildHslScheduledStopPoint(r));

export { scheduledStopPointInvariants };
export { vehicleModeOnScheduledStopPoint };
