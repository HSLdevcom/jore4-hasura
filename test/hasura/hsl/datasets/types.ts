import {
  Line as GenericLine,
  lineProps as genericLineProps,
  Route as GenericRoute,
  routeProps as genericRouteProps,
} from '@datasets-generic/types';

export * from '@datasets-generic/types';

export enum HslTransportTarget {
  HelsinkiInternalTraffic = 'helsinki_internal_traffic',
  EspooAndKauniainenInternalTraffic = 'espoo_and_kauniainen_internal_traffic',
  VantaaInternalTraffic = 'vantaa_internal_traffic',
  KeravaInternalTraffic = 'kerava_internal_traffic',
  KirkkonummiInternalTraffic = 'kirkkonummi_internal_traffic',
  SipooInternalTraffic = 'sipoo_internal_traffic',
  TuusulaInternalTraffic = 'tuusula_internal_traffic',
  SiuntioInternalTraffic = 'siuntio_internal_traffic',
  KeravaRegionalTraffic = 'kerava_regional_traffic',
  KirkkonummiRegionalTraffic = 'kirkkonummi_regional_traffic',
  TuusulaRegionalTraffic = 'tuusula_regional_traffic',
  SiuntioRegionalTraffic = 'siuntio_regional_traffic',
  EspooRegionalTraffic = 'espoo_regional_traffic',
  VantaaRegionalTraffic = 'vantaa_regional_traffic',
  TransverseRegional = 'transverse_regional',
}

export type HslLine = GenericLine & {
  legacy_hsl_municipality_code: LegacyHslMunicipalityCodeId;
  transport_target: HslTransportTarget;
};

export const hslLineProps: Property[] = [
  ...genericLineProps,
  'legacy_hsl_municipality_code',
  'transport_target',
];

export enum LegacyHslMunicipalityCodeId {
  LegacyNotUsed = 'legacy_not_used',
  Helsinki = 'helsinki',
  Espoo = 'espoo',
  TrainOrMetro = 'train_or_metro',
  Vantaa = 'vantaa',
  EspoonVantaaRegional = 'espoon_vantaa_regional',
  KirkkonummiAndSiuntio = 'kirkkonummi_and_siuntio',
  U_Lines = 'u_lines',
  TestingNotUsed = 'testing_not_used',
  TuusulaKeravaSipoo = 'tuusula_kerava_sipoo',
}

export type LegacyHslMunicipalityCode = {
  legacy_hsl_municipality_code: LegacyHslMunicipalityCodeId;
  jore3_code: number | null;
};

export type HslRoute = GenericRoute & {
  legacy_hsl_municipality_code: LegacyHslMunicipalityCodeId | null;
  variant: number | null;
};

export const hslRouteProps: Property[] = [
  ...genericRouteProps,
  'legacy_hsl_municipality_code',
  'variant',
];
