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
];
