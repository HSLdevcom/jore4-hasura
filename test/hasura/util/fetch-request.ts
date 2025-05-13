import { isEqual } from 'lodash';

export type FetchRequest = {
  readonly uri: string;
  readonly headers: { readonly [key in string]: string };
  readonly body: unknown;
};

export type ResponseBody = ExplicitAny;

export type FetchResponse = {
  readonly statusCode: number;
  readonly data: ExplicitAny;
};

const knownFetchRequestKeys: ReadonlyArray<string> = [
  'uri',
  'headers',
  'body',
].sort();

function assertValidRequest(request: FetchRequest) {
  const keys = Object.keys(request).sort();
  if (!isEqual(keys, knownFetchRequestKeys)) {
    throw new Error(
      `Request contains unknown options! Known request options: ${knownFetchRequestKeys}. Request: ${JSON.stringify(request, null, 2)}`,
    );
  }
}

async function parseNativeResponse(response: Response): Promise<FetchResponse> {
  const statusCode = response.status;
  const textData = await response.text();

  try {
    return { statusCode, data: JSON.parse(textData) };
  } catch {
    return { statusCode, data: textData };
  }
}

/**
 * Minimal compatability implementation of request-library's post-call.
 *
 * Makes an HTTP POST request and returns the decoded body as response.
 *
 * @param request
 */
export async function post(request: FetchRequest): Promise<ResponseBody> {
  assertValidRequest(request);

  return fetch(request.uri, {
    method: 'POST',
    headers: request.headers,
    body: JSON.stringify(request.body, null, 0),
  })
    .then(parseNativeResponse)
    .then((response) => response.data);
}
