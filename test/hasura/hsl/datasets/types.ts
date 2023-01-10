import {
  Line as GenericLine,
  LineProps as GenericLineProps,
  Route as GenericRoute,
  RouteProps as GenericRouteProps,
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
  transport_target: HslTransportTarget;
};

export const HslLineProps: Property[] = [
  ...GenericLineProps,
  'transport_target',
];

export type HslRoute = GenericRoute & {
  variant?: number | null;
};

export const HslRouteProps: Property[] = [...GenericRouteProps, 'variant'];
