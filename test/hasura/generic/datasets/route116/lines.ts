import { buildLine, buildLocalizedString } from '@datasets-generic/factories';
import { Line, VehicleMode } from '@datasets-generic/types';

export const lines: Line[] = [
  {
    ...buildLine('116', VehicleMode.Bus),
    line_id: 'eb12d002-b4ad-4071-b2eb-2291692d37d2',
    name_i18n: buildLocalizedString('Valkjärventie - Tapiola'),
    short_name_i18n: buildLocalizedString(''),
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
];
