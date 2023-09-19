import { genericTimetablesJsonSchema } from './json-schemas';
import { GenericTimetablesDatasetInput } from './types';

export const parseGenericDatasetJson = (
  input: string,
): GenericTimetablesDatasetInput => {
  const parsedJson = JSON.parse(input);
  const parsedDatasetInput = genericTimetablesJsonSchema.parse(parsedJson);
  return parsedDatasetInput;
};
