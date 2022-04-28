import validate from 'uuid-validate';

expect.extend({
  toBeValidUuid(value: string): jest.CustomMatcherResult {
    if (validate(value)) {
      return {
        pass: true,
        message: () => `Expected ${value} to be a valid UUID`,
      };
    } else {
      return {
        pass: false,
        message: () => `Expected ${value} to not be a valid UUID`,
      };
    }
  },
});

declare global {
  namespace jest {
    interface Matchers<R> {
      toBeValidUuid(): CustomMatcherResult;
    }
  }
}
