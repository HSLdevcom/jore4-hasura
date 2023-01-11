import { buildRoute } from '@datasets/factories';
import {
  InfrastructureLinkAlongRoute,
  LinkDirection,
  Route,
  RouteDirection,
} from '@datasets/types';
import { LocalDate } from 'local-date';
import { basicRouteInfraLinks, otherInfraLink } from './infrastructure-links';
import { lines } from './lines';

export const basicRoute: Route = {
  route_id: '61bef596-84a0-40ea-b818-423d6b9b1fcf',
  on_line_id: lines[0].line_id,
  ...buildRoute('1'),
  direction: RouteDirection.Northbound,
  priority: 10,
  validity_start: new LocalDate('2044-05-02'),
  validity_end: new LocalDate('2074-05-01'),
};

export const tempRouteWithSameLinks: Route = {
  route_id: '193ace57-9178-4e1f-b7dd-86a904bca05f',
  on_line_id: lines[0].line_id,
  ...buildRoute('1'),
  direction: RouteDirection.Northbound,
  priority: 20,
  validity_start: new LocalDate('2054-05-02'),
  validity_end: new LocalDate('2064-05-01'),
};

export const tempRouteWithOtherLinks: Route = {
  route_id: '7f022d59-1880-4755-8b18-071b2772af1a',
  on_line_id: lines[0].line_id,
  ...buildRoute('1'),
  direction: RouteDirection.Northbound,
  priority: 20,
  validity_start: new LocalDate('2054-05-02'),
  validity_end: new LocalDate('2064-05-01'),
};

export const routes: Route[] = [basicRoute];
export const routesWithTempRoute: Route[] = [
  basicRoute,
  tempRouteWithOtherLinks,
];

export const infrastructureLinkAlongBasicRoute: InfrastructureLinkAlongRoute[] =
  basicRouteInfraLinks.map((infraLink, index) => ({
    route_id: basicRoute.route_id,
    infrastructure_link_id: infraLink.infrastructure_link_id,
    infrastructure_link_sequence: index,
    is_traversal_forwards: infraLink.direction !== LinkDirection.Backward,
  }));

export const infrastructureLinkAlongTempRouteWithSameLinks: Partial<InfrastructureLinkAlongRoute>[] =
  infrastructureLinkAlongBasicRoute.map((infraLinkAlongRoute) => ({
    ...infraLinkAlongRoute,
    route_id: undefined,
  }));

export const infrastructureLinkAlongTempRouteWithOtherLinks: Partial<InfrastructureLinkAlongRoute>[] =
  infrastructureLinkAlongBasicRoute.map((infraLinkAlongRoute, index) =>
    index === 1
      ? {
          infrastructure_link_id: otherInfraLink.infrastructure_link_id,
          infrastructure_link_sequence: index,
          is_traversal_forwards:
            otherInfraLink.direction !== LinkDirection.Backward,
        }
      : {
          ...infraLinkAlongRoute,
          route_id: undefined,
        },
  );

export const infrastructureLinkAlongRoute: InfrastructureLinkAlongRoute[] =
  infrastructureLinkAlongBasicRoute;
export const infrastructureLinkAlongRouteWithTempRoute: InfrastructureLinkAlongRoute[] =
  [
    ...infrastructureLinkAlongBasicRoute,
    ...infrastructureLinkAlongTempRouteWithOtherLinks.map(
      (infraLinkAlongRoute) => {
        // Create clone the infraLinkAlongRoute object and set our custom properties on the clone.
        // Note that we need Object.assign({}, ...) to leave the original object untouched. (If we would
        // modify it, other tests would fail because of that.)
        return {
          ...infraLinkAlongRoute,
          route_id: tempRouteWithOtherLinks.route_id,
        } as InfrastructureLinkAlongRoute;
      },
    ),
  ];
