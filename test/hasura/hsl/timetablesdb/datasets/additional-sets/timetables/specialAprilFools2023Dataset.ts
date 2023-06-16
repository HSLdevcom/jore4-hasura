import { TimetablesDataset } from 'timetables-data-inserter';

export const specialAprilFools2023Timetable: TimetablesDataset = {
  _vehicle_schedule_frames: [
    {
      validity_start: '2023-04-01',
      validity_end: '2023-04-01',
      priority: 'Special',
      name: 'Aprillipäivä 2023',
      created_at: '2022-02-01T02:34:56.789+02:00',

      _vehicle_services: [
        {
          day_type_id: 'SATURDAY',

          _blocks: [
            {
              _vehicle_journeys: [
                {
                  _journey_pattern_ref_name: 'route123Inbound',

                  _passing_times: [
                    {
                      arrival_time: null,
                      departure_time: 'PT7H5M',
                      _scheduled_stop_point_label: 'H2201',
                    },
                    {
                      arrival_time: 'PT7H15M',
                      departure_time: 'PT7H15M',
                      _scheduled_stop_point_label: 'H2202',
                    },
                    {
                      arrival_time: 'PT7H22M',
                      departure_time: 'PT7H22M',
                      _scheduled_stop_point_label: 'H2203',
                    },
                    {
                      arrival_time: 'PT7H27M',
                      departure_time: null,
                      _scheduled_stop_point_label: 'H2204',
                    },
                  ],
                },
                {
                  vehicle_journey_id: '5fcabadd-ee62-4455-904b-c652c14b57f0',
                  _journey_pattern_ref_name: 'route123Outbound',

                  _passing_times: [
                    {
                      arrival_time: null,
                      departure_time: 'PT7H5M',
                      _scheduled_stop_point_label: 'H2201',
                    },
                    {
                      arrival_time: 'PT7H15M',
                      departure_time: 'PT7H15M',
                      _scheduled_stop_point_label: 'H2202',
                    },
                    {
                      arrival_time: 'PT7H19M',
                      departure_time: 'PT7H19M',
                      _scheduled_stop_point_label: 'H2203',
                    },
                    {
                      arrival_time: 'PT7H25M',
                      departure_time: null,
                      _scheduled_stop_point_label: 'H2204',
                    },
                  ],
                },
              ],
            },
          ],
        },
      ],
    },
  ],
};
