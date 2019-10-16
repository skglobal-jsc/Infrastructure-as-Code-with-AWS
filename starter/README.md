# Serverless Stack with NodeJS & AWS
This is a starting point for the project, it contain ready to go NodeJS backend framework with skeleton of AWS services.

* Amazon Cognito
* Amazon S3
* Amazon API Gateway
* Amazon Lambda
* Amazon SNS, SES
* AWS Appsync
* Amazon Pinpoint
* Amazon X-Ray
* Amazon CloudWatch

## Prerequisites
There are a few prerequisites you need to install and configure:

* [Install Node.js and NPM](#p1)
* [Installing the Serverless Framework](#p2)
* [Configuring your AWS Account with the `aws-cli`](#p3)

If you already have these prerequisites setup you can skip ahead to [create new Service](#s2) step.

### Install Node.js and NPM<a name="p1"></a>

- Follow these [installation instructions](https://nodejs.org/en/download/).
- At the end, you should be able to run `node -v` from your command line and get a result like this...

```sh
$ node -v
vx.x.x
```

- You should also be able to run `npm -v` from your command line and should see...

```sh
$ npm -v
x.x.x
```

### Installing the Serverless Framework<a name="p2"></a>

Open up a terminal and type `npm install -g serverless` to install Serverless.

```bash
npm install -g serverless
```

Once the installation process is done you can verify that Serverless is installed successfully by running the following command in your terminal:

```bash
serverless
```

To see which version of serverless you have installed run:

```bash
serverless --version
```

### Configuring your AWS Account with the `aws-cli`<a name="p3"></a>

To set them up through the `aws-cli` [install it first](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) then run `aws configure` [to configure the aws-cli and credentials](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html):

```bash
$ aws configure
AWS Access Key ID [None]: [Your Key ID]
AWS Secret Access Key [None]: [Your Secret Key]
Default region name [None]: [Your Region]
Default output format [None]: ENTER
```

Credentials are stored in INI format in `~/.aws/credentials`, which you can edit directly if needed. You can change the path to the credentials file via the `AWS_SHARED_CREDENTIALS_FILE` environment variable. Read more about that file in the [AWS documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files)

## Create new Service<a name="s2"></a>

Now that you’ve completed your setup, let’s create and deploy a serverless Service with follow commands.

```sh
# Create a new project
$ svn export https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/trunk/starter your-service-name

# Change into the newly created directory
$ cd your-service-name

# Install local development dependencies:
npm install

```
## Service Configuration
Before you can deploy your first project, yon need some steps to config your service.
### Define service name with serverless.yml file

```yml
# serverless.yml
service: your-service-name # change service name
```

### Basic configuration
**SNS Authentication Configuration**

* Update `configs/auth.json`, for more detail of setup please refer to [example](https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/tree/master/example) 

```
{
  ...
  "authProvidersUserPool": ["Facebook", "Google"],
  "hostedUIProviderCreds": "json value",
  "hostedUIProviderMeta": "json value",
  ...
}
```
**PUSH Configuration**

* Create 2 platform applications. 1 for FCM, 1 for APN, please see this [doc](https://docs.aws.amazon.com/sns/latest/dg/sns-mobile-application-as-subscriber.html) for more detail instruction.
* Update `configs/push.json` with 2 ARN which created above

```
{
  ...
  "applicationTopic": "${self:service}-${self:provider.stage}-App",
  "FCM_APP_ARN": "MY_FCM_APP_ARN",
  "APN_APP_ARN": "MY_APN_APP_ARN"
  ...
}
```

If you have experience with serverless framework, just go ahead for more advance configuration.

### Deploy the Service

Use this command to deploy your service for the first time and after you make changes to your Functions, Events or Resources in `serverless.yml` and want to deploy all changes within your Service at the same time.

```bash
serverless deploy -v
```

### Output configuration info for client side setup
After deploy successful, a config file will be created at `output/aws-exports.json`. Use this file for configuring at the front-end side. Beside that, all information is written to stdout, below is an output sample file.

```
{
  OAuthRedirectURI: 'https://skg-sample-dev.auth.us-west-2.amazoncognito.com/oauth2/idpresponse',
  AppClientSecret: 'u1fakp0dp9uoatv6lcadrq7dnplaasscsk6gqh5q3dj3bld9v5s',
  AppClientID: '26hdkes4aj2othmq4jm6rqjnpg',
  HostedUIDomain: 'skg-sample-dev.auth.us-west-2.amazoncognito.com',
  OAuthMetadata: '{"AllowedOAuthFlows":["code"],"AllowedOAuthScopes":["phone","email","openid","profile","aws.cognito.signin.user.admin"],"CallbackURLs":["http://localhost:3000/user/signed-in/","myapp://"],"LogoutURLs":["http://localhost:3000/","myapp://"]}',
  ServerlessDeploymentBucketName: 'skg-sample-dev-serverlessdeploymentbucket-190t35b8yxme4',
  UserPoolName: 'skg-sample_userpool_dev',
  AppClientIDMobile: '1jfik0fdvhp7d990vu5d5esn9',
  UserPoolId: 'us-west-2_XWSj44NrT',
  AppClientIDWeb: '5agj5h3pe20jvjth8iotqeg96j',
  PinpointId: '09790c212b034e98a890cb1fe47e8e01',
  PinpointRegion: 'us-west-2',
  SkgsampledevapiGraphQlApiUrl: 'https://wskrnncm2fathgx53h2mmxfw6a.appsync-api.us-west-2.amazonaws.com/graphql',
  S3Region: 'us-west-2',
  ProjectRegion: 'us-west-2',
  IdentityPoolId: 'us-west-2:0f101b0b-e44a-431a-bc71-cdeebd33170b',
  CognitoRegion: 'us-west-2',
  S3BucketName: 'skg-sample-dev-s3bucket-1ehvnvw76o0aj',
  PinpointAppName: 'skg-sample_dev',
  IdentityPoolName: 'IdentityPool_oS2xgGboYq44',
  ServiceEndpoint: 'https://i0nbmgnrmb.execute-api.us-west-2.amazonaws.com/dev'
}

```	
That's it, for example of configuration, please refer to [example](https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/tree/master/example) for more detail. Happy coding!
