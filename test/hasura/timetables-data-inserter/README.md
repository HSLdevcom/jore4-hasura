# Timetables Data Inserter

The Timetables Data Inserter (TDI) provides a way for easy representation of (test) data
for Jore4 timetables database and a way to insert it.

## Basic idea

The data is represented as a tree structure.
The children of each entity are listed under that entity,
and ids for foreign keys will be assigned automatically based on this structure.

For example, input:

```
const input = {
  _vehicle_schedule_frames: {
    winter2022: {
      _vehicle_services: {
        monFri: {
          day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
        }
      }
    }
  }
};
```

when built would get ids generated and assigned as such:

```
const builtDataset = buildGenericTimetablesDataset(input);

{
  _vehicle_schedule_frames: {
    winter2022: {
      vehicle_schedule_frame_id: '2bc19ab4-f5c2-455b-870d-e8806a5ec82b'

      _vehicle_services: {
        monFri: {
          vehicle_schedule_frame_id: '2bc19ab4-f5c2-455b-870d-e8806a5ec82b'
          vehicle_service_id: '4c60c2e4-3519-4f9d-b788-a187175e7a4e',
          day_type_id: defaultDayTypeIds.MONDAY_FRIDAY,
        }
      }
    }
  }
};
```

Typically, as in above example, the children are listed under a record for easier access,
though in some cases arrays are used instead when it makes more sense.

Most (if not all) properties are optional in input files, but will be populated for the built result.
Input objects will not be modified: a new object is returned.
The built result will have same structure as the input did.

In some cases there is no clear parent-child relationship
between two entities that need to be linked with foreign keys.
Then the keys of entity records will be used for linking.
An example of this is the `vehicle_journey` -> `journey_pattern_ref` relation:

```
export const defaultTimetablesDataset = {
  _vehicle_schedule_frames: {
    // ...
      _vehicle_journeys: {
        outbound: {
          _journey_pattern_ref_name: 'route123Outbound',
        }
      }
    // ...
  },

  _journey_pattern_refs: {
    route123Outbound: { /* ... */}
  },
}
```

If the `journey_pattern_ref` with name of `_journey_pattern_ref_name` is not found in dataset passed to build,
the build will fail.

## Structure

The TDI supports both `generic` and `hsl` schemas of Jore4.
Code for these is placed under `generic` and `hsl` subfolders.
The HSL version typically imports code from generic side and thus extends it.

## Basic usage, tips and tricks

Current test suites and data sets offer quite a few examples on how to create test data and user the TDI.

It might be a good practice to try to utilize existing datasets and possibly modify them in suites
instead of always creating completely new dataset files.

Because (typically) there are no ids in the dataset files,
they can be cloned and modified and thus more complex situations can be created easily.
Combining datasets can be done with eg. the `mergeTimetablesDatasets` method (basically a lodash merge)
or manually.

### Typings

When writing a new dataset from scratch, it is a good idea to add the dataset type **initially**.
This allows the IDE to autocomplete the properties:

```
export const newDataset: GenericTimetablesDatasetInput = {
```

However, for the final result the explicit type should be removed.
If type is left in place, the autocomplete won't work when trying to access properties of the dataset.

```
export const newDataset = {
```

Same applies if you are writing only smaller parts of dataset, eg. just `GenericVehicleScheduleFrameInput`.

### Debugging and random ids

The latest **built** dataset can be automatically written into a file.
This could help debugging failing tests, which can be difficult sometimes with random ids.

To activate this feature, set `export const writeLatestTimetablesDatasetToFile = true;` in [config.ts](../config.ts).
The built dataset will then be written to [test/hasura/latest-dataset.json](../latest-dataset.json) when tests are ran.
This file is overwritten on each dataset build.

### Accessing built dataset

Often in tests one needs to know the ids of entities for expects.
These can be viewed from the built dataset.

Unfortunately accessing the built dataset does not autocomplete keys of records.
But because the built dataset has same structure as input,
you can initially type the path using the input instead so that IDE will autocomplete,
and then just swap the variable from input to built dataset:

```
const builtDataset = buildGenericTimetablesDataset(inputDataset);
// This does not autocomplete: you need to know the "winter2022" and "monFri" keys.
const service = builtDataset._vehicle_schedule_frames.winter2022._vehicle_services.monFri;

// But this would autocomplete everything.
// Just type out the path and then swap `inputDataset` -> `builtDataset` after.
const service = inputDataset._vehicle_schedule_frames.winter2022._vehicle_services.monFri;
```

#### Dataset helper

For deeply nested properties accessing the built dataset like this can be a bit verbose.
The dataset helper tries to help this by providing methods for retrieving nested entities from built dataset.

So, instead of this:

```
const id = builtDataset
  ._vehicle_schedule_frames.winter2022
  ._vehicle_services.monFri
  ._blocks.block
  ._vehicle_journeys.route123Inbound1
  .vehicle_journey_id
```

you can do this:

```
const datasetHelper = createTimetablesDatasetHelper(builtDefaultDataset);
const id = datasetHelper.getVehicleJourney('route123Inbound1').vehicle_journey_id;
```

Do note that requirement for this is that the used name (in the example above, `route123Inbound1`), must be **unique** in the built dataset.
That is, same name can't be in use for that same level entity under different parents.
Otherwise the helper would have to return multiple results.
If such a case were about to happen, an error is thrown instead.

Because of this it is a good idea to try to keep keys in records specific enough that they would be unique even if datasets are combined.

## CLI

The TDI can also be used via a CLI.
Purpose of this is to make it possible to use the tool from non-JS/TS code.

Input files for CLI use mostly same structure as the Typescript version.
Main difference is that some fields have different types, eg. Dates and enums are represented as eg. strings.
See the `example.json` files in [generic](./generic/example.json) and [hsl](./hsl/example.json) folders for the format.

### Usage

Prequisites:

```
cd test/hasura
yarn install
yarn timetables-data-inserter:build
```

The CLI can take input as either file path or via stdin:

```
yarn timetables-data-inserter:cli insert generic ./input1.json
yarn timetables-data-inserter:cli insert generic < ./input1.json
```

The CLI also writes the built dataset to stdout.
The purpose of `--silent` flag here is to suppress yarn output which would result in an invalid JSON.

```
yarn --silent timetables-data-inserter:cli insert generic < ./input1.json > built-dataset-output.json
```

The CLI uses database details from [config.ts](../config.ts) by default.
If different details need to be used, they can be passed as parameters.
See the help for details: `yarn timetables-data-inserter:cli insert --help`

## TODO and ideas

- Use the inserter in other repositories
- Move to its own package, instead of being under hasura tests.
  - This way it would be easier to use from other repositories. Now all kinds of unnecessary npm packages must be installed (eg. jest) just to run the inserter.
  - Should probably still be kept under this repository, so that typings stay up to date
- Somehow get autocomplete to work for built dataset
  - Note: this has been attempted already, with generics, but we couldn't get it to work
- Currently the TDI still uses some code from outside the package. These could perhaps be moved inside TDI.
- Make this tool more generic so it could be more easily applied to other data models
- Create similar tool for the route database
