// Trick for preventing linter warnings in places where any is needed as type
type ExplicitAny = any; // eslint-disable-line @typescript-eslint/no-explicit-any

// descriptor for a Hasura object's field
type GeoProperty = {
  propName: string;
  isGeoProp: boolean;
};
type Property = string | GeoProperty;

type PropArray = Property[];

type TableLikeConfigCommonProps = {
  name: string;
  props: Property[];
};

type JsonDataSource = Record<string, unknown>[];
type FileDataSource = string;
type DataSource = JsonDataSource | FileDataSource;
type TableConfig = TableLikeConfigCommonProps & {
  data: DataSource;
  isView?: never;
};

type ViewConfig = TableLikeConfigCommonProps & {
  data?: never;
  isView: true;
};

type TableLikeConfig = TableConfig | ViewConfig;

// using ExplicitAny instead of unknown so that also interface types would be compatible
type PlainObject = Record<string, ExplicitAny>;
