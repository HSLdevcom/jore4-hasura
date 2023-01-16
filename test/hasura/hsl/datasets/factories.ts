import {
  buildLine as buildGenericLine,
  buildRoute as buildGenericRoute,
} from '@datasets-generic/factories';
import {
  HslLine,
  HslMunicipalityCodeId,
  HslRoute,
  HslTransportTarget,
} from '@datasets-hsl/types';

export type RequiredKeys<T, K extends keyof T> = Required<Pick<T, K>>;

export const buildHslLine = (
  input: RequiredKeys<HslLine, 'label' | 'primary_vehicle_mode'>,
) => {
  return {
    ...buildGenericLine(input.label, input.primary_vehicle_mode),
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
    hsl_municipality_code: HslMunicipalityCodeId.Helsinki,
    variant: null,
    ...(input || {}),
  } as HslRoute;
};
