import { DateTime } from 'luxon';
import { buildLine } from 'generic/networkdb/datasets/factories';
import { Line, VehicleMode } from 'generic/networkdb/datasets/types';

export const lines: Line[] = [
  {
    ...buildLine('1', VehicleMode.Bus),
    line_id: '0b0bd5dc-09ed-4f85-8d8f-de862145c5a0',
    priority: 10,
    validity_start: DateTime.fromISO('2044-05-02'),
    validity_end: null,
  },
];
