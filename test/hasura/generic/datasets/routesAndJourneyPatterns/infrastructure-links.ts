import {
  InfrastructureLink,
  LinkDirection,
  VehicleSubmode,
  VehicleSubmodeOnInfrastructureLink,
} from '@datasets-generic/types';

export const infrastructureLinks: InfrastructureLink[] = [
  {
    infrastructure_link_id: 'ced51f16-71ad-49c0-8785-0903240e5a78',
    direction: LinkDirection.Forward,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.0, 60.4, 0],
        [25.4, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 22044,
    external_link_source: 'digiroad_r',
    external_link_id: '1',
  },
  {
    infrastructure_link_id: '96f5419d-5641-46e8-b61e-660db08a87c4',
    direction: LinkDirection.BiDirectional,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.4, 0],
        [25.5, 60.1, 0],
        [25.7, 60.1, 0],
        [25.7, 60.3, 0],
        [25.4, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 87224,
    external_link_source: 'digiroad_r',
    external_link_id: '2',
  },
  {
    infrastructure_link_id: 'd654ff08-a7c3-4799-820c-6d61147dd1ad',
    direction: LinkDirection.Backward,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.4, 0],
        [25.7, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 16352,
    external_link_source: 'digiroad_r',
    external_link_id: '3',
  },
  {
    infrastructure_link_id: '9c73bf64-4392-4720-b3f4-6815544451b2',
    direction: LinkDirection.BiDirectional,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.4, 0],
        [25.5, 60.6, 0],
        [25.3, 60.6, 0],
        [25.4, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 56844,
    external_link_source: 'digiroad_r',
    external_link_id: '4',
  },
  {
    infrastructure_link_id: 'c922cc35-46e7-4681-b6ef-60673fc25103',
    direction: LinkDirection.Forward,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.4, 0],
        [25.7, 60.6, 0],
        [25.4, 60.8, 0],
      ],
    },
    estimated_length_in_metres: 55362,
    external_link_source: 'digiroad_r',
    external_link_id: '5',
  },
  {
    infrastructure_link_id: '2efa8900-da39-45f1-b47b-b575c56e91d7',
    direction: LinkDirection.BiDirectional,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.8, 0],
        [25.2, 60.6, 0],
        [25.4, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 49651,
    external_link_source: 'digiroad_r',
    external_link_id: '6',
  },
  {
    infrastructure_link_id: '5fc1c57b-adc2-4cc1-9f53-68aef9e64916',
    direction: LinkDirection.BiDirectional,
    shape: {
      type: 'LineString',
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:EPSG::4326',
        },
      },
      coordinates: [
        [25.4, 60.4, 0],
        [25.3, 60.2, 0],
        [25.1, 60.2, 0],
        [25.4, 60.4, 0],
      ],
    },
    estimated_length_in_metres: 61814,
    external_link_source: 'digiroad_r',
    external_link_id: '7',
  },
];

export const vehicleSubmodeOnInfrastructureLink: VehicleSubmodeOnInfrastructureLink[] =
  [
    {
      infrastructure_link_id: infrastructureLinks[0].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[0].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericTram,
    },
    {
      infrastructure_link_id: infrastructureLinks[1].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[1].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.TallElectricBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[2].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[3].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[4].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[5].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
    {
      infrastructure_link_id: infrastructureLinks[6].infrastructure_link_id,
      vehicle_submode: VehicleSubmode.GenericBus,
    },
  ];
