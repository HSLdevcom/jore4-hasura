const { readdirSync } = require('node:fs');

const processDir = (path) => {
  const migrationDirs = readdirSync(path);
  migrationDirs.forEach((dir) => {
    console.log('dir: ', dir);
  });
}

processDir('./generic/default')
