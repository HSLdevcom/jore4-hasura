// Trick for preventing linter warnings in places where any is needed as type
type ExplicitAny = any; // eslint-disable-line @typescript-eslint/no-explicit-any

// descriptor for a Hasura object's field
type GeoProperty = {
  propName: string;
  isGeoProp: boolean;
};
type Property = string | GeoProperty;

type TableSchema<TTableName extends readonly string> = {
  name: TTableName;
  props: Property[];
};
// note: the table's name appears both in the key (for easy searchability) and in the schema object
// (for encapsulating data that belongs together for querying)
type TableSchemaMap<TTableName extends readonly string> = Record<
  TTableName,
  TableSchema<TTableName>
>;

type JsonDataSource = Record<string, unknown>[];
type FileDataSource = string;
type DataSource = JsonDataSource | FileDataSource;

type TableData<TTableName extends readonly string> = {
  name: TTableName;
  data: DataSource;
};

// using ExplicitAny instead of unknown so that also interface types would be compatible
type PlainObject = Record<string, ExplicitAny>;
