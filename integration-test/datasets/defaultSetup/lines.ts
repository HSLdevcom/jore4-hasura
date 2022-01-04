import { Line, VehicleMode } from "@datasets/types";

export const lines: Line[] = [
  {
    line_id: "0b0bd5dc-09ed-4f85-8d8f-de862145c5a0",
    name_i18n: "transport bus line 1",
    short_name_i18n: "line 1",
    description_i18n: "transport bus line from Someplace to Anotherplace",
    primary_vehicle_mode: VehicleMode.Bus,
    label: "1",
    priority: 10,
    validity_start: new Date("2044-05-02 23:11:32Z"),
    validity_end: null,
  },
  {
    line_id: "33677499-a521-4b30-8bcf-8e6ad1c88691",
    name_i18n: "transport bus line 2",
    short_name_i18n: "line 2",
    description_i18n: "transport bus line from SomeplaceX to AnotherplaceY",
    primary_vehicle_mode: VehicleMode.Bus,
    label: "2",
    priority: 10,
    validity_start: new Date("2044-05-01 23:11:32Z"),
    validity_end: new Date("2045-05-01 23:11:32Z"),
  },
  {
    line_id: "40497e4c-84a9-430c-be52-cf2af57a7b21",
    name_i18n: "transport tram line 34",
    short_name_i18n: "line 34",
    description_i18n:
      "transport tram line from Sometramplace to Anothertramplace",
    primary_vehicle_mode: VehicleMode.Tram,
    label: "34",
    priority: 20,
    validity_start: null,
    validity_end: new Date("2045-06-01 23:11:32Z"),
  },
  {
    line_id: "3578a9df-9e29-430c-a2d8-2058b38beab8",
    name_i18n: "transport tram line with high priority",
    short_name_i18n: "line 77",
    description_i18n: "transport tram line 77 with high priority",
    primary_vehicle_mode: VehicleMode.Tram,
    label: "77",
    priority: 30,
    validity_start: null,
    validity_end: new Date("2045-06-01 23:11:32Z"),
  },
];
