import { lines as genericLines } from '@datasets-generic/defaultSetup/lines';
import { genericLineToHsl } from '@datasets-hsl/factories';
import { HslLine } from '@datasets-hsl/types';

export const hslLines: HslLine[] = genericLines.map((l) => genericLineToHsl(l));
