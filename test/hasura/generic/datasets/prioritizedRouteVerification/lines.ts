import { Line, VehicleMode } from '@datasets-generic/types';
import { LocalDate } from 'local-date';
import { buildLine } from '../factories';

export const lines: Line[] = [
  {
    ...buildLine('1', VehicleMode.Bus),
    line_id: '0b0bd5dc-09ed-4f85-8d8f-de862145c5a0',
    priority: 10,
    validity_start: new LocalDate('2044-05-02'),
    validity_end: null,
  },
];