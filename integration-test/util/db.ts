import { Pool } from "pg";

export const query = (connectionPool: Pool, query: string) =>
  new Promise((resolve, reject) => {
    connectionPool.connect((err, client) => {
      if (err) {
        reject(err);
      } else {
        client.query(query, (err, res) => {
          if (err) {
            reject(err);
          } else {
            resolve(res);
          }
          client.release();
        });
      }
    });
  });
