/* eslint-disable no-undef */
/* eslint-disable import/no-extraneous-dependencies */
const { writeEnvFile, writeConfFile } = require('./utils');

const { stackName } = serverless.service.provider;

const getStackOutputs = async (provider, stage, region) => {
  const result = await provider.request('CloudFormation', 'describeStacks', { StackName: stackName }, stage, region);

  const outputsArray = result.Stacks[0].Outputs;

  const outputs = {};
  for (let i = 0; i < outputsArray.length; i += 1) {
    outputs[outputsArray[i].OutputKey] = outputsArray[i].OutputValue;
  }

  return outputs;
};

const setupFrontendEnvFile = async () => {
  // eslint-disable-next-line no-undef
  const provider = serverless.getProvider('aws');
  // eslint-disable-next-line no-undef
  const { stage, region } = options;

  console.log(`stage = ${stage}, region = ${region}`);

  const res = await getStackOutputs(provider, stage, region);

  const result = {
    aws_project_region: region,
    aws_cognito_identity_pool_id: res.IdentityPoolId,
    aws_cognito_region: res.CognitoRegion,
    aws_user_pools_id: res.UserPoolId,
    aws_user_pools_web_client_id: res.AppClientIDWeb,
    oauth: {
      domain: res.HostedUIDomain,
      scope: ['phone', 'email', 'openid', 'profile', 'aws.cognito.signin.user.admin'],
      redirectSignIn: JSON.parse(res.OAuthMetadata).CallbackURLs,
      redirectSignOut: JSON.parse(res.OAuthMetadata).LogoutURLs,
      responseType: 'code',
    },
    federationTarget: 'COGNITO_USER_POOLS',
    aws_mobile_analytics_app_id: res.PinpointId,
    aws_mobile_analytics_app_region: res.PinpointRegion,
    aws_user_files_s3_bucket: res.S3BucketName,
    aws_user_files_s3_bucket_region: res.S3Region,
    API: {
      endpoints: [
        {
          name: 'PushAPI',
          endpoint: res.ServiceEndpoint,
        },
      ],
    },
  };

  console.log(res);
  await writeConfFile(
    JSON.stringify({
      appId: res.PinpointId,
      appName: res.PinpointAppName,
    }),
  );
  await writeEnvFile(JSON.stringify(result));
};

setupFrontendEnvFile();
