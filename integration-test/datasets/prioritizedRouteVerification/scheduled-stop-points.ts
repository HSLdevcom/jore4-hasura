import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleModeOnScheduledStopPoint,
  VehicleMode,
  ScheduledStopPointInvariant,
} from '@datasets/types';
import { basicRouteInfraLinks, otherInfraLink } from './infrastructure-links';
import { uniqBy } from 'lodash';

export const scheduledStopPointsOfBasicJourneyPattern: ScheduledStopPoint[] = [
  {
    scheduled_stop_point_id: '3f604abf-06a9-42c6-90fc-649bf7d8c5eb',
    located_on_infrastructure_link_id:
      basicRouteInfraLinks[0].infrastructure_link_id,
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
    validity_start: new Date('2025-01-01 12:34:56'),
    validity_end: new Date('2095-02-01 12:34:56'),
  },
  {
    scheduled_stop_point_id: 'bd29c482-b97d-44e4-89db-666a8f21a6db',
    located_on_infrastructure_link_id:
      basicRouteInfraLinks[1].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2',
    priority: 10,
    validity_start: new Date('2025-01-01 12:34:56'),
    validity_end: new Date('2095-02-01 12:34:56'),
  },
  {
    scheduled_stop_point_id: 'c8441d63-0825-4765-b889-8d2f9b560ff4',
    located_on_infrastructure_link_id:
      basicRouteInfraLinks[2].infrastructure_link_id,
    direction: LinkDirection.Backward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop3',
    priority: 10,
    validity_start: new Date('2025-01-01 12:34:56'),
    validity_end: new Date('2095-02-01 12:34:56'),
  },
  {
    scheduled_stop_point_id: '62794519-6d69-4663-b203-2c93051b3a10',
    located_on_infrastructure_link_id:
      basicRouteInfraLinks[3].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop4',
    priority: 10,
    validity_start: new Date('2025-01-01 12:34:56'),
    validity_end: new Date('2095-02-01 12:34:56'),
  },
];

export const tempScheduledStopPointWithConflictingInfraLinkOrder: ScheduledStopPoint =
  {
    scheduled_stop_point_id: 'ca0e374e-7d0b-4d83-87fd-f40b2e406910',
    located_on_infrastructure_link_id:
      basicRouteInfraLinks[3].infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [100.1, 70.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2',
    priority: 20,
    validity_start: new Date('2054-05-02 23:11:32Z'),
    validity_end: new Date('2064-05-02 23:11:32Z'),
  };

export const tempScheduledStopPointOnInfraLinkNotPresentInBasicRoute: ScheduledStopPoint =
  {
    scheduled_stop_point_id: '92cff986-e7dc-44ae-87ee-dd31b263a456',
    located_on_infrastructure_link_id: otherInfraLink.infrastructure_link_id,
    direction: LinkDirection.Forward,
    measured_location: {
      type: 'Point',
      coordinates: [12.1, 11.2, 0],
      crs: {
        properties: { name: 'urn:ogc:def:crs:EPSG::4326' },
        type: 'name',
      },
    },
    label: 'stop2',
    priority: 20,
    validity_start: new Date('2054-05-02 23:11:32Z'),
    validity_end: new Date('2064-05-02 23:11:32Z'),
  };

export const scheduledStopPoints = scheduledStopPointsOfBasicJourneyPattern;

export const scheduledStopPointInvariants: ScheduledStopPointInvariant[] =
  uniqBy(scheduledStopPointsOfBasicJourneyPattern, 'label').map(
    (scheduledStopPoint) => ({
      label: scheduledStopPoint.label,
    }),
  );

export const vehicleModeOnScheduledStopPoint: VehicleModeOnScheduledStopPoint[] =
  scheduledStopPoints.map((scheduledStopPoint) => ({
    scheduled_stop_point_id: scheduledStopPoint.scheduled_stop_point_id,
    vehicle_mode: VehicleMode.Bus,
  }));
