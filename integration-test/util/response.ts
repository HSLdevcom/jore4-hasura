import { Response } from "request";

export const checkErrorResponse = (response: Response) => {
  if (response.statusCode >= 200 && response.statusCode < 300)
    throw new Error("Request succeeded even though it was expected to fail");

  expect(response).toEqual(
    expect.objectContaining({
      errors: expect.any(Array),
    })
  );
};