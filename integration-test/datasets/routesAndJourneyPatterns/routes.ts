import { buildRoute } from '@datasets/factories';
import {
  InfrastructureLinkAlongRoute,
  Route,
  RouteDirection,
} from '@datasets/types';
import { infrastructureLinks } from './infrastructure-links';
import { lines } from './lines';
import { scheduledStopPoints } from './scheduled-stop-points';

export const routes: Route[] = [
  {
    ...buildRoute('1'),
    route_id: '61bef596-84a0-40ea-b818-423d6b9b1fcf',
    on_line_id: lines[0].line_id,
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: null,
  },
  {
    ...buildRoute('2'),
    route_id: '91994146-0569-44be-b2f1-da3c073d416c',
    on_line_id: lines[0].line_id,
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-02-02 23:11:32Z'),
  },
  {
    ...buildRoute('3'),
    route_id: '4b8f3830-d827-412c-bcf5-5e76e178bf87',
    on_line_id: lines[0].line_id,
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-04-02 23:11:32Z'),
  },
  {
    ...buildRoute('4'),
    route_id: '77f43d0d-ce64-419d-99b9-8990969678d3',
    on_line_id: lines[0].line_id,
    direction: RouteDirection.Southbound,
    priority: 20,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-06-02 23:11:32Z'),
  },
  {
    ...buildRoute('2A'),
    route_id: '127de975-8e1b-4ef5-b782-dd54971f3e1c',
    on_line_id: lines[0].line_id,
    direction: RouteDirection.Northbound,
    priority: 10,
    validity_start: new Date('2044-05-02 23:11:32Z'),
    validity_end: new Date('2064-08-02 23:11:32Z'),
  },
  {
    ...buildRoute('5'),
    route_id: '833f3ba2-3b3e-4db8-adee-430773b6c4f6',
    on_line_id: lines[0].line_id,
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
