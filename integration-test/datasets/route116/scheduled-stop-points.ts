import {
  LinkDirection,
  ScheduledStopPoint,
  VehicleMode,
  VehicleModeOnScheduledStopPoint,
} from "@datasets/types";

export const scheduledStopPoints: ScheduledStopPoint[] = [
  {
    scheduled_stop_point_id: "237a7d4b-bfbb-42cd-ba4c-d0dcdf0e7fc8",
    measured_location: {
      type: "Point",
      coordinates: [24.79862800088397, 60.17811556241601, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "234d892b-06e6-4d84-991b-306e6e9ed32c",
    direction: LinkDirection.Backward,
    label: "WeeGee-talo",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "405cf0dd-89de-4a49-b9b3-fd93061cf144",
    measured_location: {
      type: "Point",
      coordinates: [24.79588142290432, 60.181456142738945, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "ff98fffe-4cf3-49cb-aa70-61ea6755522e",
    direction: LinkDirection.Backward,
    label: "Kaskenkaataja",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "0d9b70bc-1eff-4657-88fa-73bce5062934",
    measured_location: {
      type: "Point",
      coordinates: [24.796149118257755, 60.17860846246427, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "db137251-f6f1-4425-b0fd-48c9c6e23c5a",
    direction: LinkDirection.Backward,
    label: "Ahertajankuja",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "994ab02f-e4d4-4743-8af4-611783709f85",
    measured_location: {
      type: "Point",
      coordinates: [24.803219322616375, 60.17775124023471, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "51e11be1-d893-4eb3-9750-5e892a194f02",
    direction: LinkDirection.Forward,
    label: "Kulttuuriaukio",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "231f6797-21f5-404c-8934-e5e180e9d152",
    measured_location: {
      type: "Point",
      coordinates: [24.809122487945533, 60.178445782940564, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "3119a956-5fc3-4f6c-97d6-81b3ed724f6c",
    direction: LinkDirection.Backward,
    label: "Tapiolan uimahalli",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "3c451d12-f912-4f21-a331-573e20410344",
    measured_location: {
      type: "Point",
      coordinates: [24.810657009587118, 60.17362497695666, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "0a2a1662-e5cd-457a-8b20-b70ab24fdd37",
    direction: LinkDirection.Forward,
    label: "Sateentie (24)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "050cee7c-953d-40a6-af47-8f1edc7dcf9c",
    measured_location: {
      type: "Point",
      coordinates: [24.80241599178783, 60.172000006688926, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "07f6b3bd-e3b0-4d9b-8b1c-19e4b662b9fd",
    direction: LinkDirection.Forward,
    label: "Tuuliniitty (31)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "b7e0370e-72ad-46a2-bab1-30bcf1027cc3",
    measured_location: {
      type: "Point",
      coordinates: [24.8019023441453, 60.171965955578145, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "45030a73-2ae7-4c21-9cad-a22f1397a27d",
    direction: LinkDirection.Backward,
    label: "Tuuliniitty (32)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "d455b413-db93-4321-a22a-70c7739a94ea",
    measured_location: {
      type: "Point",
      coordinates: [24.806127967828655, 60.176786562161496, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "0772c96e-2a81-462c-81b4-3598870c8b56",
    direction: LinkDirection.Backward,
    label: "Tapionaukio",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "79f5ae02-6974-4448-9466-7601b7ae54d0",
    measured_location: {
      type: "Point",
      coordinates: [24.81029663753904, 60.173612179351736, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "faae5a3c-9124-4508-9c3f-8464c05b307f",
    direction: LinkDirection.Backward,
    label: "Sateentie (23)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "a6698564-cd9d-4293-b0a6-c94fd962bb25",
    measured_location: {
      type: "Point",
      coordinates: [24.79822120270886, 60.171182770287025, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "38fabfbf-07cf-46da-9644-401e3c46a209",
    direction: LinkDirection.Forward,
    label: "Tuulikuja",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "5c135b2b-1c85-4b57-abec-4a793336ca29",
    measured_location: {
      type: "Point",
      coordinates: [24.814638262692547, 60.173313567162, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "6ede4fde-4dc9-46bc-82c4-f7564f5fb7ba",
    direction: LinkDirection.Forward,
    label: "Sateenkaari",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "335de7c6-7e98-4b30-87b4-bfcabf0ef0e7",
    measured_location: {
      type: "Point",
      coordinates: [24.800469792470444, 60.17527136336079, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "dc145f4b-8382-4c8d-a546-805af0fcb681",
    direction: LinkDirection.Backward,
    label: "Länsituulenkuja",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "8025166f-27c1-4973-9f07-8b28c5ba3166",
    measured_location: {
      type: "Point",
      coordinates: [24.79994288646075, 60.17599917802331, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "dc145f4b-8382-4c8d-a546-805af0fcb681",
    direction: LinkDirection.Backward,
    label: "Pohjantie (42)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
  {
    scheduled_stop_point_id: "be69cd74-fccf-463a-8f21-ad1f9a43934b",
    measured_location: {
      type: "Point",
      coordinates: [24.803008460097253, 60.17472332942501, 0],
      crs: {
        properties: { name: "urn:ogc:def:crs:EPSG::4326" },
        type: "name",
      },
    },
    located_on_infrastructure_link_id: "4608e126-f3d2-4518-9ce8-800ac976fa8b",
    direction: LinkDirection.Forward,
    label: "Tapiola (M) (11)",
    priority: 10,
    validity_start: null,
    validity_end: null,
  },
];

export const vehicleModeOnScheduledStopPoint: VehicleModeOnScheduledStopPoint[] =
  scheduledStopPoints.map((stop) => ({
    scheduled_stop_point_id: stop.scheduled_stop_point_id,
    vehicle_mode: VehicleMode.Bus,
  }));
