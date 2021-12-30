import {
  InfrastructureLink,
  LinkDirection,
  VehicleSubmode,
  VehicleSubmodeOnInfrastructureLink,
} from "@datasets/types";

export const infrastructureLinks: InfrastructureLink[] = [
  {
    infrastructure_link_id: "ced51f16-71ad-49c0-8785-0903240e5a78",
    direction: LinkDirection.Forward,
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
    external_link_id: "1",
  },
  {
    infrastructure_link_id: "96f5419d-5641-46e8-b61e-660db08a87c4",
    direction: LinkDirection.BiDirectional,
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
    external_link_id: "2",
  },
  {
    infrastructure_link_id: "d654ff08-a7c3-4799-820c-6d61147dd1ad",
    direction: LinkDirection.Backward,
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
    external_link_id: "3",
  },
  {
    infrastructure_link_id: "9c73bf64-4392-4720-b3f4-6815544451b2",
    direction: LinkDirection.BiDirectional,
    shape: {
      type: "LineString",
      crs: {
        type: "name",
        properties: {
          name: "urn:ogc:def:crs:EPSG::4326",
        },
      },
      coordinates: [
        [12.1, 13.2, 0],
        [4.3, 1.1, 0],
      ],
    },
    estimated_length_in_metres: 1400,
    external_link_source: "digiroad_r",
    external_link_id: "4",
  },
  {
    infrastructure_link_id: "c922cc35-46e7-4681-b6ef-60673fc25103",
    direction: LinkDirection.Forward,
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
    external_link_id: "5",
  },
  {
    infrastructure_link_id: "1bc1b232-c264-4472-80da-c48815628314",
    direction: LinkDirection.BiDirectional,
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
    external_link_id: "6",
  },
  {
    infrastructure_link_id: "122836f0-3408-4f35-b39c-c6f260170fa6",
    direction: LinkDirection.Backward,
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
    external_link_id: "7",
  },
  {
    infrastructure_link_id: "3280b64e-9a5c-490f-a95b-7fec98f80e27",
    direction: LinkDirection.BiDirectional,
    shape: {
      type: "LineString",
      crs: {
        type: "name",
        properties: {
          name: "urn:ogc:def:crs:EPSG::4326",
        },
      },
      coordinates: [
        [12.1, 13.2, 0],
        [4.3, 1.1, 0],
      ],
    },
    estimated_length_in_metres: 1400,
    external_link_source: "digiroad_r",
    external_link_id: "8",
  },
];

export const vehicleSubmodeOnInfrastructureLink: VehicleSubmodeOnInfrastructureLink[] =
  [
    {
      infrastructure_link_id: "ced51f16-71ad-49c0-8785-0903240e5a78",
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: "ced51f16-71ad-49c0-8785-0903240e5a78",
      vehicle_submode: VehicleSubmode.GenericTram,
    },
    {
      infrastructure_link_id: "96f5419d-5641-46e8-b61e-660db08a87c4",
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: "96f5419d-5641-46e8-b61e-660db08a87c4",
      vehicle_submode: VehicleSubmode.TallElectricBus,
    },
    {
      infrastructure_link_id: "d654ff08-a7c3-4799-820c-6d61147dd1ad",
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: "9c73bf64-4392-4720-b3f4-6815544451b2",
      vehicle_submode: VehicleSubmode.GenericFerry,
    },
    {
      infrastructure_link_id: "1bc1b232-c264-4472-80da-c48815628314",
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: "c922cc35-46e7-4681-b6ef-60673fc25103",
      vehicle_submode: VehicleSubmode.GenericMetro,
    },
  ];
