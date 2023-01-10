import {
  buildLine as buildGenericLine,
  buildRoute as buildGenericRoute,
} from '@datasets-generic/factories';
import { HslTransportTarget, VehicleMode } from '@datasets-hsl/types';

// The generic data is typically from either factory methods or defaultDataset, which are different types, so using generics here in HSL converters.

export const genericLineToHsl = <T>(genericLine: T) => {
  const defaultHslLineProps: {
    transport_target: HslTransportTarget;
  } = {
    transport_target: HslTransportTarget.HelsinkiInternalTraffic,
  };

  return {
    ...genericLine,
    ...defaultHslLineProps,
  };
};

export const buildHslLine = (label: string, vehicleMode: VehicleMode) => {
  const genericLine = buildGenericLine(label, vehicleMode);
  return genericLineToHsl(genericLine);
};

export const genericRouteToHsl = <T>(genericRoute: T) => {
  const defaultHslRouteProps: {
    variant: number | null;
  } = {
    variant: null,
  };

  return {
    ...genericRoute,
    ...defaultHslRouteProps,
  };
};

export const buildHslRoute = (postfix: string) => {
  const genericRoute = buildGenericRoute(postfix);
  return genericRouteToHsl(genericRoute);
};
