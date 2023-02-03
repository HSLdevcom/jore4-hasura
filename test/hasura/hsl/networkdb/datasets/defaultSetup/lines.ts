import { lines as genericLines } from 'generic/networkdb/datasets/defaultSetup/lines';
import { buildHslLine } from 'hsl/networkdb/datasets/factories';
import { HslLine } from 'hsl/networkdb/datasets/types';

export const hslLines: HslLine[] = genericLines.map(buildHslLine);
