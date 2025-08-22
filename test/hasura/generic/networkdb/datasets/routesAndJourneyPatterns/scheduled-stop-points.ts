import { uniqBy } from 'lodash';
import { DateTime } from 'luxon';
import {
  LinkDirection,
  ScheduledStopPoint,
  ScheduledStopPointInvariant,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
} from 'generic/networkdb/datasets/types';
import { infrastructureLinks } from './infrastructure-links';

export const scheduledStopPoints: ScheduledStopPoint[] = [
  {
    scheduled_stop_point_id: '3f604abf-06a9-42c6-90fc-649bf7d8c5eb',
    located_on_infrastructure_link_id:
      infrastructureLinks[0].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.1, 60.4, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop1',
    priority: 10,
    validity_start: DateTime.fromISO('2035-01-01'),
    validity_end: DateTime.fromISO('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '5be29866-4a74-45f3-9b85-b0717283231b',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.5, 60.1, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop3',
    priority: 10,
    validity_start: DateTime.fromISO('2035-02-03'),
    validity_end: null,
    timing_place_id: null,
  },
  {
    scheduled_stop_point_id: 'd269d7e7-3ff4-48eb-8a07-3acec1bc349d',
    located_on_infrastructure_link_id:
      infrastructureLinks[2].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.5, 60.4, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2',
    priority: 30,
    validity_start: null,
    validity_end: DateTime.fromISO('2064-01-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: 'f150e375-ebe0-448b-a974-cdc2f482268d',
    located_on_infrastructure_link_id:
      infrastructureLinks[3].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.4, 60.6, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopX',
    priority: 10,
    validity_start: DateTime.fromISO('2035-01-01'),
    validity_end: DateTime.fromISO('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '02eca2f4-743a-4505-99ed-52390970a3d2',
    located_on_infrastructure_link_id:
      infrastructureLinks[4].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.7, 60.6, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopY',
    priority: 10,
    validity_start: DateTime.fromISO('2035-02-03'),
    validity_end: null,
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: 'c3101b7f-1bda-4770-82f1-526e977ac3cc',
    located_on_infrastructure_link_id:
      infrastructureLinks[5].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.2, 60.6, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stopZ',
    priority: 20,
    validity_start: null,
    validity_end: DateTime.fromISO('2064-01-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '1a794279-266e-4826-b08e-155d7cde4bce',
    located_on_infrastructure_link_id:
      infrastructureLinks[0].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.3, 60.4, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop1X',
    priority: 10,
    validity_start: DateTime.fromISO('2035-01-01'),
    validity_end: DateTime.fromISO('2065-01-31'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '4927238b-9bd9-4f86-bba2-3810a2e97f51',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.7, 60.1, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop3X',
    priority: 10,
    validity_start: DateTime.fromISO('2035-02-03'),
    validity_end: null,
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '222a0415-ce8c-442c-8e35-d56528bb7e29',
    located_on_infrastructure_link_id:
      infrastructureLinks[2].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.6, 60.4, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2X',
    priority: 30,
    validity_start: null,
    validity_end: DateTime.fromISO('2064-01-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '431ab46f-3271-40bb-ab14-e217813a6a7f',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [25.7, 60.3, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop4X',
    priority: 10,
    validity_start: DateTime.fromISO('2030-02-03'),
    validity_end: DateTime.fromISO('2032-02-02'),
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '370c55b6-8848-11ed-a1eb-0242ac120002',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.6, 60.1, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop5X',
    priority: 10,
    validity_start: DateTime.fromISO('2035-02-03'),
    validity_end: null,
    timing_place_id: '7b6663b6-0feb-466b-89ed-200e889de472',
  },
  {
    scheduled_stop_point_id: '60439d2c-8848-11ed-a1eb-0242ac120002',
    located_on_infrastructure_link_id:
      infrastructureLinks[1].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [25.7, 60.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop6X',
    priority: 10,
    validity_start: DateTime.fromISO('2035-02-03'),
    validity_end: null,
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
      scheduled_stop_point_id: scheduledStopPoints[6].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[6].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Tram,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[7].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[8].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[9].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[10].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
    {
      scheduled_stop_point_id: scheduledStopPoints[11].scheduled_stop_point_id,
      vehicle_mode: VehicleMode.Bus,
    },
  ];
