/* eslint-disable no-unused-vars */
import sns from './sns';

const response = (code, body) => ({
  statusCode: code,
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': true,
  },
  body: typeof body === 'string' ? body : JSON.stringify(body, null, 2),
});

export const registerDeviceToken = async (event) => {
  try {
    const { token, userInfo, platform } = JSON.parse(event.body);
    // make a endpoint url
    const res = await sns.createEndpoint(token, userInfo, platform);
    const { EndpointArn } = res;
    // subscribe automatic this endpoint to app topic.
    // TODO In prod, it should handle by trigger.
    const subscribeRes = await sns.subscribeAppTopic(EndpointArn, userInfo);
    return response(200, {
      endpointArn: EndpointArn,
      subscriptionArn: subscribeRes.SubscriptionArn,
    });
  } catch (error) {
    return response(error.statusCode || 500, error.message || "Couldn't register Device Token");
  }
};

// This is sample API. Dont use this in production
export const sendMsg = async (event) => {
  try {
    const { message, userInfo = {} } = JSON.parse(event.body);

    const { id, email } = userInfo;
    const attributes = id
      ? {
        topic: {
          DataType: 'String',
          StringValue: id,
        },
        userEmail: {
          DataType: 'String',
          StringValue: email,
        },
      }
      : {
        topic: {
          DataType: 'String',
          StringValue: 'ALL',
        },
      };
    const res = await sns.publishToAppTopic(message, attributes);

    return response(200, res);
  } catch (error) {
    return response(error.statusCode || 500, error.message || "Couldn't send message at the moment");
  }
};
