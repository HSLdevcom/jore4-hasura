import {
  InfrastructureLinkAlongRoute,
  Route,
  RouteDirection,
} from '@datasets/types';
import { scheduledStopPoints } from './scheduled-stop-points';
import { lines } from './lines';
import { infrastructureLinks } from './infrastructure-links';

export const routes: Route[] = [
  {
    route_id: '61bef596-84a0-40ea-b818-423d6b9b1fcf',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 1',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[0].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
    label: 'route 1',
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: null,
  },
  {
    route_id: '91994146-0569-44be-b2f1-da3c073d416c',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 2',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[3].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[4].scheduled_stop_point_id,
    label: 'route 2',
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-02-02 23:11:32Z'),
  },
  {
    route_id: '4b8f3830-d827-412c-bcf5-5e76e178bf87',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 3',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[7].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[8].scheduled_stop_point_id,
    label: 'route 3',
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-04-02 23:11:32Z'),
  },
  {
    route_id: '77f43d0d-ce64-419d-99b9-8990969678d3',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 4',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[3].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[4].scheduled_stop_point_id,
    label: 'route 4',
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-06-02 23:11:32Z'),
  },
  {
    route_id: '127de975-8e1b-4ef5-b782-dd54971f3e1c',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 2A',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[3].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[4].scheduled_stop_point_id,
    label: 'route 2A',
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-08-02 23:11:32Z'),
  },
  {
    route_id: '833f3ba2-3b3e-4db8-adee-430773b6c4f6',
    on_line_id: lines[0].line_id,
    description_i18n: 'route 5',
    starts_from_scheduled_stop_point_id:
      scheduledStopPoints[0].scheduled_stop_point_id,
    ends_at_scheduled_stop_point_id:
      scheduledStopPoints[2].scheduled_stop_point_id,
    label: 'route 5',
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-10-02 23:11:32Z'),
  },
];

export const infrastructureLinkAlongRoute: InfrastructureLinkAlongRoute[] = [
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[0].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[1].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 25,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
    infrastructure_link_sequence: 30,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
    infrastructure_link_sequence: 35,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[0].route_id,
    infrastructure_link_id: infrastructureLinks[2].infrastructure_link_id,
    infrastructure_link_sequence: 40,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[1].route_id,
    infrastructure_link_id: infrastructureLinks[3].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[1].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[2].route_id,
    infrastructure_link_id: infrastructureLinks[1].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[2].route_id,
    infrastructure_link_id: infrastructureLinks[2].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[3].route_id,
    infrastructure_link_id: infrastructureLinks[3].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[3].route_id,
    infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[3].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 30,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[4].route_id,
    infrastructure_link_id: infrastructureLinks[3].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[4].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[0].infrastructure_link_id,
    infrastructure_link_sequence: 10,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[1].infrastructure_link_id,
    infrastructure_link_sequence: 20,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
    infrastructure_link_sequence: 25,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
    infrastructure_link_sequence: 30,
    is_traversal_forwards: true,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
    infrastructure_link_sequence: 35,
    is_traversal_forwards: false,
  },
  {
    route_id: routes[5].route_id,
    infrastructure_link_id: infrastructureLinks[2].infrastructure_link_id,
    infrastructure_link_sequence: 40,
    is_traversal_forwards: false,
  },
];
