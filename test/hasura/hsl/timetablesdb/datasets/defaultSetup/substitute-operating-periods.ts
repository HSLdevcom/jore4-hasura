import { SubstituteOperatingPeriod } from '../types';

export const substituteOperatingPeriodByNames = {
  aprilFools: {
    substitute_operating_period_id: 'e2df8923-6641-474e-a355-d531e8433888',
    is_preset: false,
    period_name: 'AprilFools substitute operating period',
  },
};
export const substituteOperatingPeriod: SubstituteOperatingPeriod[] =
  Object.values(substituteOperatingPeriodByNames);
