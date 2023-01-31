import differenceBy from 'lodash/differenceBy';

export const findTableSchema = <TTableName extends string>(
  tableSchemas: TableSchema<TTableName>[],
  tableName: TTableName,
) => {
  const foundSchema = tableSchemas.find(
    (tableSchema) => tableSchema.name === tableName,
  );
  if (!foundSchema) {
    throw new Error(`Cannot find table schema with name '${tableName}'!`);
  }
  return foundSchema;
};

export type ValueFunction<TItem> = (item: TItem) => ExplicitAny;
export const upsertList = <TItem extends ExplicitAny>(
  originalItems: TItem[],
  upsertItems: TItem[],
  valueFunction: ValueFunction<TItem>,
): TItem[] => {
  // these items didn't exist in the original list, will be added as new items
  const newItems = differenceBy(upsertItems, originalItems, valueFunction);

  // these items do exist in the original list, they are replaced
  const replacedItems = originalItems.reduce<TItem[]>((sum, currentItem) => {
    const replacedItem = upsertItems.find(valueFunction);
    return [...sum, replacedItem ?? currentItem];
  }, []);

  // append the new items after the replaced items
  return [...replacedItems, ...newItems];
};
