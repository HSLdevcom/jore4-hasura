import validate from 'uuid-validate';

expect.extend({
  toBeValidUuid(value: string): jest.CustomMatcherResult {
    if (validate(value)) {
      return {
        pass: true,
        message: () => `Expected ${value} to be a valid UUID`,
      };
    }
    return {
      pass: false,
      message: () => `Expected ${value} to not be a valid UUID`,
    };
  },
});

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace jest {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    interface Matchers<R> {
      toBeValidUuid(): CustomMatcherResult;
    }
  }
}
