import { Direction, InfrastructureLink } from "@datasets/types";

export const infrastructureLinks: InfrastructureLink[] = [
  {
    infrastructure_link_id: "ced51f16-71ad-49c0-8785-0903240e5a78",
    direction: Direction.Forward,
    shape: {
      type: "LineString",
      crs: {
        type: "name",
        properties: {
          name: "urn:ogc:def:crs:EPSG::4326",
        },
      },
      coordinates: [
        [12.1, 11.2, 0],
        [12.3, 10.1, 0],
      ],
    },
    estimated_length_in_metres: 1200,
    external_link_source: "digiroad_r",
    external_link_id: 1,
  },
  {
    infrastructure_link_id: "96f5419d-5641-46e8-b61e-660db08a87c4",
    direction: Direction.BiDirectional,
    shape: {
      type: "LineString",
      crs: {
        type: "name",
        properties: {
          name: "urn:ogc:def:crs:EPSG::4326",
        },
      },
      coordinates: [
        [13.1, 12.2, 0],
        [15.3, 14.1, 0],
      ],
    },
    estimated_length_in_metres: 1100,
    external_link_source: "digiroad_r",
    external_link_id: 2,
  },
  {
    infrastructure_link_id: "d654ff08-a7c3-4799-820c-6d61147dd1ad",
    direction: Direction.Backward,
    shape: {
      type: "LineString",
      crs: {
        type: "name",
        properties: {
          name: "urn:ogc:def:crs:EPSG::4326",
        },
      },
      coordinates: [
        [11.1, 10.2, 0],
        [9.3, 2.1, 0],
      ],
    },
    estimated_length_in_metres: 1600,
    external_link_source: "digiroad_r",
    external_link_id: 3,
  },
];