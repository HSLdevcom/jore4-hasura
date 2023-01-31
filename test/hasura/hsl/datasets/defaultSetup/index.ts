import { defaultGenericNetworkDbData } from '@datasets-generic/defaultSetup';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { upsertList } from '@util/schema';
import { HslNetworkDbTables } from 'hsl/schema';

export const defaultHslNetworkDbData: TableData<HslNetworkDbTables>[] =
  upsertList(
    defaultGenericNetworkDbData,
    [
      {
        name: 'route.line',
        data: hslLines,
      },
      {
        name: 'route.route',
        data: hslRoutes,
      },
    ],
    (tableSchema) => tableSchema.name,
  );
