import { defaultTableConfig as genericDefaultTableConfig } from '@datasets-generic/defaultSetup';
import { hslLines } from '@datasets-hsl/defaultSetup/lines';
import { hslRoutes } from '@datasets-hsl/defaultSetup/routes';
import { HslLineProps, HslRouteProps } from '@datasets-hsl/types';

const tableConfigHslOverrides: TableLikeConfig[] = [
  { name: 'route.line', data: hslLines, props: HslLineProps },
  { name: 'route.route', data: hslRoutes, props: HslRouteProps },
];

const hslDefaultTableConfig: TableLikeConfig[] = genericDefaultTableConfig.map(
  (genericTableConfigEntry) => {
    const override = tableConfigHslOverrides.find(
      (hslConfigEntry) =>
        genericTableConfigEntry.name === hslConfigEntry.name &&
        genericTableConfigEntry.isView === hslConfigEntry.isView,
    );

    return override || genericTableConfigEntry;
  },
);

export const defaultTableConfig = hslDefaultTableConfig;