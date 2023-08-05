import {
  createTimetablesDatasetHelper,
  sanityCheckLabelGroupResult,
} from 'timetables-data-inserter/generic/timetables-dataset-helper';
import { flattenHslDataset } from './table-data';
import {
  HslTimetablesDatasetOutput,
  SubstituteOperatingDayByLineTypeOutput,
} from './types';

export const createHslTimetablesDatasetHelper = (
  builtDataset: HslTimetablesDatasetOutput,
) => {
  const flattened = flattenHslDataset(builtDataset);

  // TODO: could these be done with generics?..
  const substituteOperatingDayByLineTypesByLabel =
    flattened.substituteOperatingPeriods
      .flatMap((sop) =>
        Object.entries(sop._substitute_operating_day_by_line_types),
      )
      .reduce((result, [label, sodblt]) => {
        const labelGroup = result[label] || [];
        labelGroup.push(sodblt);
        return {
          ...result,
          [label]: labelGroup,
        };
      }, {} as Record<string, SubstituteOperatingDayByLineTypeOutput[]>);

  const genericTimetablesHelper = createTimetablesDatasetHelper(builtDataset);

  return {
    ...genericTimetablesHelper,
    getSubstituteOperatingDayByLineTypes(
      label: string,
    ): SubstituteOperatingDayByLineTypeOutput {
      const forLabel = substituteOperatingDayByLineTypesByLabel[label];
      sanityCheckLabelGroupResult('vehicle service', label, forLabel);
      return forLabel[0];
    },
  };
};
