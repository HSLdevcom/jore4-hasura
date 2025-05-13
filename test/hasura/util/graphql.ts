import { hasuraRequestTemplate } from '@config';
import { post } from '@util/fetch-request';

export const postQuery = (query: string) => {
  return post({
    ...hasuraRequestTemplate,
    body: {
      query,
    },
  });
};

export const addMutationWrapper = (query: string) => `mutation {
  ${query}
}`;
