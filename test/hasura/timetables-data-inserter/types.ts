import { GenericTimetablesDatasetInput } from './generic/types';
import { HslTimetablesDatasetInput } from './hsl/types';

export type TimetablesDatasetInput =
  | GenericTimetablesDatasetInput
  | HslTimetablesDatasetInput;
