import { VehicleServiceBlock } from '../types';
import { vehicleServicesByName } from './vehicle-services';

export const vehicleServiceBlocksByName = {
  // Vehicle 1 Mon-Fri
  v1MonFri: {
    block_id: '882e131f-3622-4da4-8adb-5104625a4290',
    vehicle_service_id: vehicleServicesByName.v1MonFri.vehicle_service_id,
  },
  // Vehicle 1 Sat
  v1Sat: {
    block_id: 'ee2864c7-8ee6-4c8c-94ee-e1fbe1a02fdf',
    vehicle_service_id: vehicleServicesByName.v1Sat.vehicle_service_id,
  },
  // Vehicle 1 Sun
  v1Sun: {
    block_id: 'a8545f76-92ef-4d11-9351-9ed4b9ba0ffb',
    vehicle_service_id: vehicleServicesByName.v1Sun.vehicle_service_id,
  },
};
export const vehicleServiceBlocks: VehicleServiceBlock[] = Object.values(
  vehicleServiceBlocksByName,
);
