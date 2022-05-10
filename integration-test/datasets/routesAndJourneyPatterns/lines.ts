import { buildLine } from '@datasets/factories';
import { Line, VehicleMode } from '@datasets/types';

export const lines: Line[] = [
  {
    ...buildLine('1', VehicleMode.Bus),
    line_id: '0b0bd5dc-09ed-4f85-8d8f-de862145c5a0',
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: null,
  },
];
