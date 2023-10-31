import { vehicleServiceBlocks } from 'generic/timetablesdb/datasets/defaultSetup';
import { VehicleServiceBlock } from 'generic/timetablesdb/datasets/types';
import { hslVehicleServicesByName } from './vehicle-services';

export const hslVehicleServiceBlocksByName = {
  // Vehicle 1 Ascension day
  v1Ascension: {
    block_id: 'd911c6eb-35c1-4bd5-9268-6daf3d52ed55',
    vehicle_service_id: hslVehicleServicesByName.v1Ascension.vehicle_service_id,
    preparing_time: null,
    finishing_time: null,
  },
};

// TODO: Add actual conversion to hsl model when needed
export const hslVehicleServiceBlocks: VehicleServiceBlock[] =
  vehicleServiceBlocks.concat(Object.values(hslVehicleServiceBlocksByName));
