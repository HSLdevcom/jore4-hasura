import {
  LocalizedString,
  TypeOfLine,
  VehicleMode,
} from '@datasets-generic/types';

export const buildLocalizedString = (str: string): LocalizedString => ({
  fi_FI: str,
  sv_FI: `${str} SV`,
});

export const buildTypeOfLine = (vehicleMode: VehicleMode) => {
  switch (vehicleMode) {
    case VehicleMode.Tram:
      return TypeOfLine.CityTramService;
    case VehicleMode.Bus:
      return TypeOfLine.RegionalBusService;
    default:
      return TypeOfLine.RegionalBusService;
  }
};

export const buildLine = (label: string, vehicleMode: VehicleMode) => ({
  label,
  name_i18n: buildLocalizedString(`transport ${vehicleMode} line ${label}`),
  short_name_i18n: buildLocalizedString(`line ${label}`),
  primary_vehicle_mode: vehicleMode,
  type_of_line: buildTypeOfLine(vehicleMode),
});

export const buildRoute = (postfix: string) => ({
  label: `route ${postfix}`,
  name_i18n: buildLocalizedString(`route ${postfix}`),
  description_i18n: buildLocalizedString(`description ${postfix}`),
  origin_name_i18n: buildLocalizedString(`origin ${postfix}`),
  origin_short_name_i18n: buildLocalizedString(`origin short ${postfix}`),
  destination_name_i18n: buildLocalizedString(`destination ${postfix}`),
  destination_short_name_i18n: buildLocalizedString(
    `destination short ${postfix}`,
  ),
});
