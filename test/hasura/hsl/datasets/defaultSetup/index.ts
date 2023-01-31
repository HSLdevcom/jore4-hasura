import { defaultGenericNetworkDbData } from '@datasets-generic/defaultSetup';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { HslNetworkDbTables } from '@datasets-hsl/schema';
import { mergeLists } from '@util/schema';

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
