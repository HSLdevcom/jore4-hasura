import differenceBy from 'lodash/differenceBy';

// TODO: convenience function to support multiple data structures. Remove if proven unnecessary
export const findTableSchema = <TTableName extends string>(
  tableSchemas: TableSchemaMap<TTableName>,
  tableName: TTableName,
) => tableSchemas[tableName];

// TODO: convenience function to support merging two lists. Remove if proven unnecessary
export type ValueFunction<TItem> = (item: TItem) => ExplicitAny;
export const mergeLists = <TItem extends ExplicitAny>(
  originalItems: TItem[],
  upsertItems: TItem[],
  valueFunction: ValueFunction<TItem>,
): TItem[] => {
  // these items didn't exist in the original list, will be added as new items
  const newItems = differenceBy(upsertItems, originalItems, valueFunction);

  // these items do exist in the original list, they are replaced
  const replacedItems = originalItems.reduce<TItem[]>((result, currentItem) => {
    const replacedItem = upsertItems.find(
      (item) => valueFunction(item) === valueFunction(currentItem),
    );
    return [...result, replacedItem || currentItem];
  }, []);

  // append the new items after the replaced items
  return [...replacedItems, ...newItems];
};
