import { hslTimetablesJsonSchema } from './json-schemas';
import { HslTimetablesDatasetInput } from './types';

export const parseHslDatasetJson = (
  input: string,
): HslTimetablesDatasetInput => {
  const parsedJson = JSON.parse(input);
  const parsedDatasetInput = hslTimetablesJsonSchema.parse(parsedJson);
  return parsedDatasetInput;
};
