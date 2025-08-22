// resolves the promises in sequential order (instead of concurrently as in Promise.all)
export const promiseSequence = async (promises: Promise<ExplicitAny>[]) => {
  const results = [];

  for (let i = 0; i < promises.length; i++) {
    // eslint-disable-next-line no-await-in-loop
    const result = await promises[i];
    results.push(result);
  }
  return results;
};
