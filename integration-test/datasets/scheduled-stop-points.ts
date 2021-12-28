import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleModeOnScheduledStopPoint,
  VehicleMode,
} from "@datasets/types";
import { infrastructureLinks } from "@datasets/infrastructure-links";

export const scheduledStopPoints: ScheduledStopPoint[] = [
  {
    scheduled_stop_point_id: "3f604abf-06a9-42c6-90fc-649bf7d8c5eb",
    located_on_infrastructure_link_id:
      infrastructureLinks[0].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: "Point",
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    label: "stop1",
    priority: 10,
    validity_start: new Date("2065-01-01 12:34:56"),
    validity_end: new Date("2065-02-01 12:34:56"),
  },
  {
    scheduled_stop_point_id: "5be29866-4a74-45f3-9b85-b0717283231b",
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: "Point",
      coordinates: [8.1, 7.2, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    label: "stop3",
    priority: 10,
    validity_start: new Date("2065-02-03 12:34:56"),
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "d269d7e7-3ff4-48eb-8a07-3acec1bc349d",
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: "Point",
      coordinates: [10.1, 9.2, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    label: "stop2",
    priority: 30,
    validity_start: null,
    validity_end: new Date("2064-01-03 12:34:56"),
  },
];

export const vehicleModeOnScheduledStopPoint: VehicleModeOnScheduledStopPoint[] =
  [
    {
      scheduled_stop_point_id: "3f604abf-06a9-42c6-90fc-649bf7d8c5eb",
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: "3f604abf-06a9-42c6-90fc-649bf7d8c5eb",
      vehicle_mode: VehicleMode.Tram,
    },
    {
      scheduled_stop_point_id: "5be29866-4a74-45f3-9b85-b0717283231b",
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: "d269d7e7-3ff4-48eb-8a07-3acec1bc349d",
      vehicle_mode: VehicleMode.Bus,
    },
  ];
