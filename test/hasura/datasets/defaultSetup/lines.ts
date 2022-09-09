import { Line, VehicleMode } from '@datasets/types';
import { buildLine, buildLocalizedString } from '../factories';

export const lines: Line[] = [
  {
    ...buildLine('1', VehicleMode.Bus),
    line_id: '0b0bd5dc-09ed-4f85-8d8f-de862145c5a0',
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: null,
  },
  {
    ...buildLine('2', VehicleMode.Bus),
    line_id: '33677499-a521-4b30-8bcf-8e6ad1c88691',
    priority: 10,
    validity_start: new Date('2044-05-01 23:11:32Z'),
    validity_end: new Date('2045-05-01 23:11:32Z'),
  },
  {
    ...buildLine('34', VehicleMode.Tram),
    line_id: '40497e4c-84a9-430c-be52-cf2af57a7b21',
    priority: 20,
    validity_start: null,
    validity_end: new Date('2045-06-01 23:11:32Z'),
  },
  {
    ...buildLine('77', VehicleMode.Tram),
    line_id: '3578a9df-9e29-430c-a2d8-2058b38beab8',
    name_i18n: buildLocalizedString('transport tram line with high priority'),
    priority: 30,
    validity_start: null,
    validity_end: new Date('2045-06-01 23:11:32Z'),
  },
  {
    ...buildLine('89', VehicleMode.Tram),
    line_id: '4ea04912-f09a-4993-b63d-4f4317cbe015',
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
];
