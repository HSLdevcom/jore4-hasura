import {
  buildLine as buildGenericLine,
  buildRoute as buildGenericRoute,
} from 'generic/networkdb/datasets/factories';
import {
  HslLine,
  HslRoute,
  HslTransportTarget,
  LegacyHslMunicipality,
} from 'hsl/networkdb/datasets/types';

export const buildHslLine = (
  input: RequiredKeys<Partial<HslLine>, 'label' | 'primary_vehicle_mode'>,
) => {
  return {
    ...buildGenericLine(input.label, input.primary_vehicle_mode),
    legacy_hsl_municipality_code: LegacyHslMunicipality.Helsinki,
    transport_target: HslTransportTarget.HelsinkiInternalTraffic,
    ...input,
  } as HslLine;
};

export const buildHslRoute = (
  input?: Partial<HslRoute>,
  postfix?: string,
): HslRoute => {
  return {
    ...(postfix ? buildGenericRoute(postfix) : {}),
    legacy_hsl_municipality_code: LegacyHslMunicipality.Helsinki,
    variant: null,
    ...(input ?? {}),
  } as HslRoute;
};
