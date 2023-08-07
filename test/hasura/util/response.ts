import { Response } from 'request';

/**
 * NOTE: This currently works differently than expectNoErrorResponse()
 * as this is a higher order function and the other one is not despite
 * the same naming. To use this you need to call
 * expectErrorResponse('ExpectedErrorMessageHere')(response),
 * TODO: refactor this to be consistent with expectNoErrorResponse(), by
 * making this a normal function, or by making the function name more
 * precise. Also the expectedErrorMsg is actually expectedErrorMsgSubstring
 */
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
