import { timetablesDbConfig } from '@config';
import {
  DbConnection,
  closeDbConnection,
  createDbConnection,
  singleQuery,
} from '@util/db';
import { setupDb } from '@util/setup';
import { defaultJourneyPatternRefsByName } from 'generic/timetablesdb/datasets/defaultSetup';
import { RouteDirection } from 'generic/timetablesdb/datasets/types';
import { Duration } from 'luxon';
import {
  GenericTimetablesDatasetInput,
  GenericTimetablesDatasetOutput,
  VehicleJourneyInput,
  buildGenericTimetablesDataset,
  createGenericTableData,
  defaultDayTypeIds,
} from 'timetables-data-inserter';
import { createTimetablesDatasetHelper } from 'timetables-data-inserter/generic/timetables-dataset-helper';

describe('Vehicle service sequential integrity', () => {
  let dbConnection: DbConnection;

  beforeAll(() => {
    dbConnection = createDbConnection(timetablesDbConfig);
  });

  afterAll(() => closeDbConnection(dbConnection));

  const createBaseDataset = () => {
    return {
      _vehicle_schedule_frames: {
        frame: {
          vehicle_schedule_frame_id: 'fed628d8-1a37-43d4-bb7c-73fb13bf8fed',
          name: 'Test frame',
          _vehicle_services: {
            monFri: {
              vehicle_service_id: 'aaaf2fda-7b1f-4f71-8739-c50ac7608aaa',
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              _blocks: {},
            },
            alternativeMonFri: {
              vehicle_service_id: 'bbbe2889-2465-47f3-a915-6bb6dfa08bbb',
              day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
              _blocks: {},
            },
            sat: {
              vehicle_service_id: 'ccc189a5-f1de-49c0-910d-4e3872fe7ccc',
              day_type_id: defaultDayTypeIds.SATURDAY,
              _blocks: {},
            },
          },
        },
      },
      _journey_pattern_refs: defaultJourneyPatternRefsByName,
    };
  };

  const createDuration = (hoursMinutes: string) => {
    const hoursMinutesRegex = /^\d{1,2}:\d{2}$/;
    if (!hoursMinutesRegex.test(hoursMinutes)) {
      throw new Error(
        `Invalid format for hours and minutes "${hoursMinutes}".`,
      );
    }
    const [hours, minutes] = hoursMinutes.split(':');
    return Duration.fromISO(`PT${hours}H${minutes}M`);
  };

  type PassingTimeParameters = [
    label: string,
    arrival: string | null,
    departure: string | null,
  ];

  const createJourney = (journey: {
    journeyPatternRefName: string;
    direction?: RouteDirection;
    turnaround?: string | null;
    layover?: string | null;
    times: Array<PassingTimeParameters>;
  }): VehicleJourneyInput => {
    return {
      _journey_pattern_ref_name: journey.journeyPatternRefName,
      layover_time: journey.layover ? createDuration(journey.layover) : null,
      turnaround_time: journey.turnaround
        ? createDuration(journey.turnaround)
        : null,
      _passing_times: journey.times.map(([label, arrival, departure]) => {
        return {
          _scheduled_stop_point_label: label,
          arrival_time: arrival ? createDuration(arrival) : null,
          departure_time: departure ? createDuration(departure) : null,
        };
      }),
    };
  };

  const createDatasetWithBlockTimes = (
    firstBlockTimes: PassingTimeParameters[],
    secondBlockTimes: PassingTimeParameters[],
  ) => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Outbound',
            times: firstBlockTimes,
          }),
        },
      },
      block2: {
        block_id: '22222222-49c7-477d-8991-222222222222',
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Inbound',
            times: secondBlockTimes,
          }),
        },
      },
    };
    return dataset;
  };

  const createSingleBlockDatasetWithJourneys = (
    journeys: Record<string, VehicleJourneyInput>,
  ) => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        _vehicle_journeys: journeys,
      },
    };

    return dataset;
  };

  // Exactly half an hour of empty time between blocks, before any preparation times.
  const createDatasetWithPreparationTimes = ({
    firstLayover,
    firstFinishing,
    secondPreparing,
    secondTurnaround,
  }: {
    firstLayover?: string | null;
    firstFinishing?: string | null;
    secondPreparing?: string | null;
    secondTurnaround?: string | null;
  }) => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        finishing_time: firstFinishing && createDuration(firstFinishing),
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Outbound',
            layover: firstLayover,
            times: [
              ['H2201', null, '7:00'],
              ['H2202', '7:15', '7:15'],
              ['H2204', '7:30', null],
            ],
          }),
        },
      },
      block2: {
        block_id: '22222222-49c7-477d-8991-222222222222',
        preparing_time: secondPreparing && createDuration(secondPreparing),
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Inbound',
            turnaround: secondTurnaround,
            times: [
              ['H2204', null, '8:00'],
              ['H2202', '8:15', '8:15'],
              ['H2201', '8:30', null],
            ],
          }),
        },
      },
    };
    return dataset;
  };

  const insertTestData = async (
    datasetInput: GenericTimetablesDatasetInput,
  ): Promise<GenericTimetablesDatasetOutput> => {
    const builtDefaultDataset = buildGenericTimetablesDataset(datasetInput);
    const tableData = createGenericTableData(builtDefaultDataset);
    await setupDb(dbConnection, tableData);
    return builtDefaultDataset;
  };

  it('should allow blocks from different vehicle_services to overlap', async () => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Outbound',
            times: [
              ['H2201', null, '7:00'],
              ['H2202', '7:15', '7:15'],
              ['H2204', '7:30', null],
            ],
          }),
        },
      },
    };

    dataset._vehicle_schedule_frames.frame._vehicle_services.alternativeMonFri._blocks =
      {
        block1: {
          block_id: '22222222-49c7-477d-8991-222222222222',
          _vehicle_journeys: {
            1: createJourney({
              journeyPatternRefName: 'route123Outbound',
              times: [
                ['H2201', null, '7:15'],
                ['H2202', '7:25', '7:25'],
                ['H2204', '7:40', null],
              ],
            }),
          },
        },
      };

    await expect(insertTestData(dataset)).resolves.not.toThrow();
  });

  it('should allow consecutive blocks that do not overlap', async () => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Outbound',
            times: [
              ['H2201', null, '7:00'],
              ['H2202', '7:15', '7:15'],
              ['H2204', '7:30', null],
            ],
          }),
        },
      },

      block2: {
        block_id: '22222222-49c7-477d-8991-222222222222',
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Inbound',
            times: [
              ['H2204', null, '7:40'],
              ['H2202', '7:50', '7:50'],
              ['H2201', '8:00', null],
            ],
          }),
        },
      },
    };

    await expect(insertTestData(dataset)).resolves.not.toThrow();
  });

  it('should allow consecutive blocks that do not overlap, with all preparation time fields', async () => {
    const dataset = createBaseDataset();
    dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks = {
      block1: {
        block_id: '11111111-fc80-4f3a-9ac2-111111111111',
        finishing_time: createDuration('0:05'),
        _vehicle_journeys: {
          1: createJourney({
            turnaround: '0:05',
            journeyPatternRefName: 'route123Outbound',
            times: [
              ['H2201', null, '7:00'],
              ['H2202', '7:15', '7:15'],
              ['H2204', '7:30', null], // With finishing and turnaround, actually ends at 7:40.
            ],
          }),
        },
      },
      block2: {
        block_id: '22222222-49c7-477d-8991-222222222222',
        preparing_time: createDuration('0:05'),
        _vehicle_journeys: {
          1: createJourney({
            journeyPatternRefName: 'route123Inbound',
            layover: '0:05',
            times: [
              ['H2204', null, '8:00'], // With preparing and layover, actually starts at 7:50
              ['H2202', '8:15', '8:15'],
              ['H2201', '8:30', null],
            ],
          }),
        },
      },
    };

    await expect(insertTestData(dataset)).resolves.not.toThrow();
  });

  describe('blocks', () => {
    it('should allow next block to start exactly when previous one ends', async () => {
      const dataset = createDatasetWithBlockTimes(
        [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
        [
          ['H2204', null, '7:30'],
          ['H2202', '7:45', '7:45'],
          ['H2201', '8:00', null],
        ],
      );

      await expect(insertTestData(dataset)).resolves.not.toThrow();
    });

    it('should fail when consecutive blocks overlap', async () => {
      const dataset = createDatasetWithBlockTimes(
        [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
        [
          ['H2204', null, '7:29'],
          ['H2202', '7:45', '7:45'],
          ['H2201', '8:00', null],
        ],
      );

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail when one block completely encompasses the other', async () => {
      const dataset = createDatasetWithBlockTimes(
        [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
        [
          ['H2204', null, '6:00'],
          ['H2203', '6:30', '6:30'],
          ['H2202', '7:45', '7:45'],
          ['H2201', '8:00', null],
        ],
      );

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    // The logic shouldn't really care about journey patterns.
    it('should fail when two blocks have same start and end times for different journey patterns', async () => {
      const dataset = createDatasetWithBlockTimes(
        [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
        [
          ['H2204', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2201', '7:30', null],
        ],
      );

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail when two blocks are identical', async () => {
      const journeys = createJourney({
        journeyPatternRefName: 'route123Outbound',
        times: [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
      });
      const dataset = createBaseDataset();
      dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks =
        {
          block1: {
            block_id: '11111111-fc80-4f3a-9ac2-111111111111',
            _vehicle_journeys: {
              1: journeys,
            },
          },
          block2: {
            block_id: '22222222-49c7-477d-8991-222222222222',
            _vehicle_journeys: {
              1: journeys,
            },
          },
        };

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail when two blocks have different times but same start and end time', async () => {
      const dataset = createDatasetWithBlockTimes(
        [
          ['H2201', null, '7:00'],
          ['H2202', '7:15', '7:15'],
          ['H2204', '7:30', null],
        ],
        [
          ['H2204', null, '7:00'],
          ['H2203', '7:10', '7:10'],
          ['H2202', '7:20', '7:20'],
          ['H2201', '7:30', null],
        ],
      );

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    describe('with preparing and finishing times', () => {
      it('should allow next block to start exactly when previous one ends', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstFinishing: '0:15',
          secondPreparing: '0:15',
        });

        await expect(insertTestData(dataset)).resolves.not.toThrow();
      });

      it('should fail if preparing time overlaps with previous block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstFinishing: null,
          secondPreparing: '0:31',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail if finishing time overlaps with next block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstFinishing: '0:31',
          secondPreparing: null,
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail if blocks overlap when both preparing and finishing time are considered', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstFinishing: '0:11',
          secondPreparing: '0:20',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });
    });

    // Test only cases when these make two blocks overlap.
    describe('with layover and turnaround times', () => {
      it('should allow next block to start exactly when previous one ends', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:15',
          secondTurnaround: '0:15',
        });

        await expect(insertTestData(dataset)).resolves.not.toThrow();
      });

      it('should fail if turnaround time overlaps with previous block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: null,
          secondTurnaround: '0:31',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail if layover time overlaps with next block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:31',
          secondTurnaround: null,
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail if blocks overlap when both turnaround and layover time are considered', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:11',
          secondTurnaround: '0:20',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });
    });

    describe('with all preparation time fields', () => {
      it('should allow next block to start exactly when previous one ends', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:05',
          firstFinishing: '0:10',
          secondPreparing: '0:10',
          secondTurnaround: '0:05',
        });

        await expect(insertTestData(dataset)).resolves.not.toThrow();
      });

      it('should fail if actual start time overlaps with previous block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          secondPreparing: '0:21',
          secondTurnaround: '0:10',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail if actual end time overlaps with next block', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:10',
          firstFinishing: '0:21',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });

      it('should fail blocks overlap when all preparation time fields are considered', async () => {
        const dataset = createDatasetWithPreparationTimes({
          firstLayover: '0:06',
          firstFinishing: '0:11',
          secondPreparing: '0:11',
          secondTurnaround: '0:06',
        });

        await expect(insertTestData(dataset)).rejects.toThrow(
          'Sequential integrity issues detected',
        );
      });
    });
  });

  // Only check cases that make two journeys overlap, without making entire blocks overlap.
  // Those overlapping block cases are already tested in previous describe.
  describe('vehicle journeys in same block', () => {
    it('should allow next journey to start exactly when previous one ends', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
        2: createJourney({
          journeyPatternRefName: 'route123Inbound',
          times: [
            ['H2204', null, '7:30'],
            ['H2202', '7:45', '7:45'],
            ['H2201', '8:00', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).resolves.not.toThrow();
    });

    it('should fail when consecutive journeys overlap', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
        2: createJourney({
          journeyPatternRefName: 'route123Inbound',
          times: [
            ['H2204', null, '7:29'],
            ['H2202', '7:45', '7:45'],
            ['H2201', '8:00', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail if turnaround time overlaps with previous journey', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
        2: createJourney({
          journeyPatternRefName: 'route123Inbound',
          turnaround: '0:15',
          times: [
            ['H2204', null, '7:40'],
            ['H2202', '7:45', '7:45'],
            ['H2201', '8:00', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail if layover time overlaps with next journey', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          layover: '0:15',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
        2: createJourney({
          journeyPatternRefName: 'route123Inbound',
          times: [
            ['H2204', null, '7:40'],
            ['H2202', '7:45', '7:45'],
            ['H2201', '8:00', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });

    it('should fail if journeys overlap when both layover and turnaround time are considered', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          layover: '0:06',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
        2: createJourney({
          journeyPatternRefName: 'route123Inbound',
          turnaround: '0:06',
          times: [
            ['H2204', null, '7:40'],
            ['H2202', '7:45', '7:45'],
            ['H2201', '8:00', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'Sequential integrity issues detected',
      );
    });
  });

  // Note: these are handled by a different constraint. Just checking that they actually are.
  describe('passing times', () => {
    it('should fail if two passing times overlap each other: arrival overlaps with previous stop', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '6:55', '7:15'],
            ['H2204', '7:30', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'passing times and their matching stop points must be in same order',
      );
    });

    it('should fail if two passing times overlap each other: departure overlaps with next stop', async () => {
      const dataset = createSingleBlockDatasetWithJourneys({
        1: createJourney({
          journeyPatternRefName: 'route123Outbound',
          times: [
            ['H2201', null, '7:00'],
            ['H2202', '7:15', '7:35'],
            ['H2204', '7:30', null],
          ],
        }),
      });

      await expect(insertTestData(dataset)).rejects.toThrow(
        'passing times and their matching stop points must be in same order',
      );
    });
  });

  describe('validation triggers', () => {
    let insertedDataset: GenericTimetablesDatasetOutput;

    beforeEach(async () => {
      const dataset = createBaseDataset();
      dataset._vehicle_schedule_frames.frame._vehicle_services.monFri._blocks =
        {
          block1: {
            block_id: '11111111-fc80-4f3a-9ac2-111111111111',
            _vehicle_journeys: {
              1: createJourney({
                journeyPatternRefName: 'route123Outbound',
                times: [
                  ['H2201', null, '7:00'],
                  ['H2202', '7:15', '7:15'],
                  ['H2204', '7:30', null],
                ],
              }),
            },
          },

          block2: {
            block_id: '22222222-49c7-477d-8991-222222222222',
            _vehicle_journeys: {
              1: createJourney({
                journeyPatternRefName: 'route123Inbound',
                times: [
                  ['H2204', null, '7:40'],
                  ['H2202', '7:50', '7:50'],
                  ['H2201', '8:00', null],
                ],
              }),
            },
          },
        };

      insertedDataset = await insertTestData(dataset);
    });

    it('should trigger on block modifications', async () => {
      const datasetHelper = createTimetablesDatasetHelper(insertedDataset);
      const firstBlock = datasetHelper.getBlock('block1');

      // Update finishing time to make first block longer -> overlaps with second one.
      await expect(
        singleQuery(
          dbConnection,
          `UPDATE vehicle_service.block
           SET "finishing_time" = 'PT12M'
           WHERE "block_id" = '${firstBlock.block_id}'`,
        ),
      ).rejects.toThrow('Sequential integrity issues detected');
    });

    it('should trigger on vehicle_journey modifications', async () => {
      const datasetHelper = createTimetablesDatasetHelper(insertedDataset);
      const secondBlockFirstJourney =
        datasetHelper.getBlock('block2')._vehicle_journeys[1];

      // Update turnaround time to make second journey longer -> makes whole block longer -> overlaps with first one.
      await expect(
        singleQuery(
          dbConnection,
          `UPDATE vehicle_journey.vehicle_journey
             SET "turnaround_time" = 'PT12M'
             WHERE "vehicle_journey_id" = '${secondBlockFirstJourney.vehicle_journey_id}'`,
        ),
      ).rejects.toThrow('Sequential integrity issues detected');
    });

    it('should trigger on timetabled_passing_time modifications', async () => {
      const datasetHelper = createTimetablesDatasetHelper(insertedDataset);
      const firstBlockLastStop =
        datasetHelper.getBlock('block1')._vehicle_journeys[1]._passing_times[2];

      await expect(
        singleQuery(
          dbConnection,
          `UPDATE passing_times.timetabled_passing_time
           SET "arrival_time" = 'PT7H45M'
           WHERE "timetabled_passing_time_id" = '${firstBlockLastStop.timetabled_passing_time_id}'`,
        ),
      ).rejects.toThrow('Sequential integrity issues detected');
    });
  });
});
