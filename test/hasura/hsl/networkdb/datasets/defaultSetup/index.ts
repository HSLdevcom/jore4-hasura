import { mergeLists } from '@util/schema';
import { defaultGenericNetworkDbData } from 'generic/networkdb/datasets/defaultSetup';
import { hslLines } from 'hsl/networkdb/datasets/defaultSetup/lines';
import { hslRoutes } from 'hsl/networkdb/datasets/defaultSetup/routes';
import { HslNetworkDbTables } from 'hsl/networkdb/datasets/schema';

export const defaultHslNetworkDbData: TableData<HslNetworkDbTables>[] =
  mergeLists(
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
