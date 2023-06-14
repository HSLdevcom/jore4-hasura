import { randomUUID } from 'crypto';

export const assignId = <T, K extends keyof T>(item: T, idField: K) => {
  return {
    // For -? See https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#improved-control-over-mapped-type-modifiers
    // In theory the latter part should be same as Required<Pick<T, K>>, but doesn't seem so.
    ...item,
    ...({
      [idField]: item[idField] || (randomUUID() as T[K]),
    } as { [P in K]-?: NonNullable<T[P]> }),
  };
};

export const assignForeignKey = <T, K extends keyof T>(
  item: T,
  fieldName: K,
  id: UUID,
) => {
  if (item[fieldName]) {
    throw new Error(`Foreign key ${fieldName.toString()} already assigned`);
  }

  return {
    ...item,
    ...({
      [fieldName]: id as T[K],
    } as { [P in K]-?: NonNullable<T[P]> }),
  };
};
