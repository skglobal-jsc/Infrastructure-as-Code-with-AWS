/* eslint-disable import/no-extraneous-dependencies */
const path = require('path');
const fs = require('fs-extra');

const writeEnvFile = async (envs) => {
  const envFile = path.join(__dirname, '..', 'outputs', 'aws-exports.json');
  await fs.ensureFile(envFile);
  fs.writeFile(envFile, envs);
};

const writeConfFile = async (envs) => {
  const envFile = path.join(__dirname, '..', 'configs', 'pinpoint.json');
  await fs.ensureFile(envFile);
  fs.writeFile(envFile, envs);
};

module.exports = { writeEnvFile, writeConfFile };
