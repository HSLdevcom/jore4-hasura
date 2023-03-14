import { Response } from 'request';

export const expectErrorResponse =
  (expectedErrorMsg?: string) => (response: Response) => {
    if (response.statusCode >= 200 && response.statusCode < 300)
      throw new Error('Request succeeded even though it was expected to fail');

    expect(response).toEqual(
      expect.objectContaining({
        errors: expect.any(Array),
      }),
    );

    if (expectedErrorMsg) {
      expect(JSON.stringify(response)).toContain(expectedErrorMsg);
    }
  };

export const expectNoErrorResponse = (response: unknown) => {
  expect(response).toEqual(
    expect.not.objectContaining({
      errors: expect.any(Array),
    }),
  );
};
