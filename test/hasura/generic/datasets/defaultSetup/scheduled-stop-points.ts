import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointInvariant,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
} from '@datasets-generic/types';
import { LocalDate } from 'local-date';
import { uniqBy } from 'lodash';
import { infrastructureLinks } from './infrastructure-links';

export const scheduledStopPoints: ScheduledStopPoint[] = [
  {
    scheduled_stop_point_id: '3f604abf-06a9-42c6-90fc-649bf7d8c5eb',
    located_on_infrastructure_link_id:
      infrastructureLinks[0].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop1',
    priority: 10,
    validity_start: new LocalDate('2065-01-01'),
    validity_end: new LocalDate('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '5be29866-4a74-45f3-9b85-b0717283231b',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [8.1, 7.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop3',
    priority: 10,
    validity_start: new LocalDate('2065-02-03'),
    validity_end: null,
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: 'd269d7e7-3ff4-48eb-8a07-3acec1bc349d',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [10.1, 9.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2',
    priority: 20,
    validity_start: null,
    validity_end: new LocalDate('2064-01-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: 'f150e375-ebe0-448b-a974-cdc2f482268d',
    located_on_infrastructure_link_id:
      infrastructureLinks[8].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopX',
    priority: 10,
    validity_start: new LocalDate('2035-01-01'),
    validity_end: new LocalDate('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '02eca2f4-743a-4505-99ed-52390970a3d2',
    located_on_infrastructure_link_id:
      infrastructureLinks[9].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [8.1, 7.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopY',
    priority: 10,
    validity_start: new LocalDate('2035-02-03'),
    validity_end: null,
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '8ef30378-1e3b-4646-aa67-e7ee8051690e',
    located_on_infrastructure_link_id:
      infrastructureLinks[4].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopZ',
    priority: 10,
    validity_start: new LocalDate('2035-01-01'),
    validity_end: new LocalDate('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: 'a1b6e453-07b1-4c31-8ade-6872994bc857',
    located_on_infrastructure_link_id:
      infrastructureLinks[5].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [10.1, 9.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopZ2',
    priority: 30,
    validity_start: null,
    validity_end: new LocalDate('2064-01-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
];

export const scheduledStopPointInvariants: ScheduledStopPointInvariant[] =
  uniqBy(scheduledStopPoints, 'label').map((scheduledStopPoint) => ({
    label: scheduledStopPoint.label,
  }));

export const vehicleModeOnScheduledStopPoint: VehicleModeOnScheduledStopPoint[] =
  [
    {
      scheduled_stop_point_id: scheduledStopPoints[0].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[0].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Tram,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[1].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[2].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[3].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[4].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[5].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[5].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Tram,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[6].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
  ];
