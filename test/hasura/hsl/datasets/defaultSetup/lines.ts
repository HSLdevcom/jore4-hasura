import { lines as genericLines } from '@datasets-generic/defaultSetup/lines';
import { buildHslLine } from '@datasets-hsl/factories';
import { HslLine } from '@datasets-hsl/types';

export const hslLines: HslLine[] = genericLines.map(buildHslLine);
