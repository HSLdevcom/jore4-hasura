import { scheduledStopPoints } from 'generic/networkdb/datasets/route116/scheduled-stop-points';
import {
  JourneyPattern,
  ScheduledStopPointInJourneyPattern,
} from 'generic/networkdb/datasets/types';

export const journeyPatterns: JourneyPattern[] = [
  {
    journey_pattern_id: 'b928b450-036e-4364-9d19-b54415519d34',
    on_route_id: '02300151-bab5-4dea-b767-73367885923e',
  },
];

export const scheduledStopPointInJourneyPattern: ScheduledStopPointInJourneyPattern[] =
  [
    '405cf0dd-89de-4a49-b9b3-fd93061cf144',
    '0d9b70bc-1eff-4657-88fa-73bce5062934',
    '237a7d4b-bfbb-42cd-ba4c-d0dcdf0e7fc8',
    '994ab02f-e4d4-4743-8af4-611783709f85',
    '237a7d4b-bfbb-42cd-ba4c-d0dcdf0e7fc8',
    '8025166f-27c1-4973-9f07-8b28c5ba3166',
    '335de7c6-7e98-4b30-87b4-bfcabf0ef0e7',
    'b7e0370e-72ad-46a2-bab1-30bcf1027cc3',
    'a6698564-cd9d-4293-b0a6-c94fd962bb25',
    '050cee7c-953d-40a6-af47-8f1edc7dcf9c',
    'be69cd74-fccf-463a-8f21-ad1f9a43934b',
    '79f5ae02-6974-4448-9466-7601b7ae54d0',
    '5c135b2b-1c85-4b57-abec-4a793336ca29',
    '3c451d12-f912-4f21-a331-573e20410344',
    '231f6797-21f5-404c-8934-e5e180e9d152',
  ].map((stopId, index) => {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const { label } = scheduledStopPoints.find(
      (scheduledStopPoint) =>
        scheduledStopPoint.scheduled_stop_point_id === stopId,
    )!;

    return {
      journey_pattern_id: journeyPatterns[0].journey_pattern_id,
      scheduled_stop_point_label: label,
      scheduled_stop_point_sequence: index,
      is_used_as_timing_point: true,
      is_loading_time_allowed: false,
      is_regulated_timing_point: false,
      is_via_point: false,
      via_point_name_i18n: null,
      via_point_short_name_i18n: null,
    };
  });
