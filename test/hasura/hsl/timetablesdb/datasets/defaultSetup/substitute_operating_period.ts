import { SubstituteOperatingPeriod } from '../types';

export const substituteOperatingPeriodByNames = {
  aprilFools: {
    substitute_operating_period_id: '0967a31a-8304-4440-9a8e-18bb67b28166',
    is_preset: false,
    period_name: 'Default korvausjakso',
  },
};
export const substituteOperatingPeriod: SubstituteOperatingPeriod[] =
  Object.values(substituteOperatingPeriodByNames);
