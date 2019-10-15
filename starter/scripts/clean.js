/* eslint-disable no-template-curly-in-string */
const { writeConfFile } = require('./utils');


const restoreConf = async () => {
  await writeConfFile(
    JSON.stringify({
      appId: 'NONE',
      appName: '${self:service}_${self:provider.stage}',
    }),
  );
};

restoreConf();
