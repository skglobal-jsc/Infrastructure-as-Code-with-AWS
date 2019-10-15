const SNS = require('aws-sdk/clients/sns');

const { FCM_APP_ARN, APN_APP_ARN, APP_TOPIC_ARN } = process.env;

const sns = new SNS({
  appVersion: '2010-03-31',
});

const PLATFORM_MAP = {
  FCM: FCM_APP_ARN,
  APN: APN_APP_ARN,
};

const makeMessage = (message) => {
  const msgBody = {
    default: message,
    APNS: `{"aps":{"alert": ${message}} }`,
    APNS_SANDBOX: `{"aps":{"alert": ${message}}}`,
    GCM: `{ "data": { "message": ${message} } }`,
  };
  return JSON.stringify(msgBody);
};

/**
 * Prepares to subscribe an endpoint by sending the endpoint a confirmation message.
 * To actually create a subscription, the endpoint owner must call the ConfirmSubscription action with the token from the confirmation message.
 * Confirmation tokens are valid for three days.
 * @param {*} name
 */

const subscribeAppTopic = (endpoint, userInfo) => sns
  .subscribe({
    Protocol: 'application', // delivery of JSON-encoded message to an EndpointArn for a mobile app and device
    TopicArn: APP_TOPIC_ARN,
    Endpoint: endpoint, // the endpoint is the EndpointArn of a mobile app and device
    ReturnSubscriptionArn: true,
    ...(userInfo && {
      Attributes: {
        FilterPolicy: JSON.stringify({
          topic: [userInfo.id, 'ALL'],
        }),
      },
    }),
  })
  .promise();

/**
 * Deletes a subscription
 * null if a request error occurs
 */
const unSubscribeAppTopic = subscriptionArn => sns
  .unsubscribe({
    SubscriptionArn: subscriptionArn,
  })
  .promise();

/**
 * Creates an endpoint for a device and mobile app on one of the supported push notification services, such as GCM and APNS.
 * @param {*} token
 * @param {*} platform
 * @param {*} userInfo
 */
const createEndpoint = (token, userInfo, platform = 'FCM') => {
  const PlatformApplicationArn = PLATFORM_MAP[platform];
  // return {EndpointArn}
  return sns
    .createPlatformEndpoint({
      PlatformApplicationArn,
      Token: token,
      ...(userInfo && { CustomUserData: JSON.stringify(userInfo) }),
    })
    .promise();
};

/**
 * Deletes the endpoint for a device and mobile app from Amazon SNS.
 * null if a request error occurs
 */
const deleteEndpoint = endpointArn => sns
  .deleteEndpoint({
    EndpointArn: endpointArn,
  })
  .promise();

const getEndpointAttributes = endpointArn => sns
  .getEndpointAttributes({
    EndpointArn: endpointArn,
  })
  .promise();

/**
 * send msg to whole app
 * @param {*} message
 */
const publishToAppTopic = (message, attributes) => {
  const params = {
    Message: makeMessage(message),
    TopicArn: APP_TOPIC_ARN,
    MessageAttributes: attributes,
  };

  return sns.publish(params).promise();
};

const publishToDevice = (message, endpointArn) => {
  const params = {
    Message: makeMessage(message),
    TargetArn: endpointArn,
  };

  return sns.publish(params).promise();
};

export default {
  client: sns,
  createEndpoint,
  deleteEndpoint,
  subscribeAppTopic,
  unSubscribeAppTopic,
  publishToAppTopic,
  publishToDevice,
  getEndpointAttributes,
};
