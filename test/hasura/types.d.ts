// Trick for preventing linter warnings in places where any is needed as type
type ExplicitAny = any; // eslint-disable-line @typescript-eslint/no-explicit-any

// descriptor for a Hasura object's field
type Property =
  | string
  | {
      propName: string;
      isGeoProp: boolean;
    };

type PropArray = Property[];

type TableLikeConfigCommonProps = {
  name: string;
  props: Property[];
};

type TableConfig = TableLikeConfigCommonProps & {
  data: Record<string, unknown>[] | string;
  isView?: never;
};

type ViewConfig = TableLikeConfigCommonProps & {
  data?: never;
  isView: true;
};

type TableLikeConfig = TableConfig | ViewConfig;
