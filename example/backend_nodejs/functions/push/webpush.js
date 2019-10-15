/* eslint-disable no-unused-vars */
/* eslint-disable no-return-await */
const mime = require('mime-types');
const webPush = require('web-push');

if (!process.env.VAPID_PUBLIC_KEY || !process.env.VAPID_PRIVATE_KEY) {
  console.log('You must set the VAPID_PUBLIC_KEY and VAPID_PRIVATE_KEY environment variables. You can use the following ones:');
  console.log(webPush.generateVAPIDKeys());
}

webPush.setVapidDetails(process.env.DOMAIN, process.env.VAPID_PUBLIC_KEY, process.env.VAPID_PRIVATE_KEY);

function response(statusCode, body, file) {
  const payload = {
    statusCode,
    body: typeof body === 'string' ? body : JSON.stringify(body, null, 2),
  };
  if (file) {
    payload.headers = { 'content-type': mime.contentType(file) };
  }
  return payload;
}

const send = (subs, payload, options) => Promise.all(
  subs.map(sub => webPush.sendNotification(sub, payload, options).catch((err) => {
    console.log('push error, delete DB now:', err);
    // throw err;
  })),
);

export const sendNotification = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const { subscription, payload, ttl = 5 } = body;
    const options = {
      TTL: ttl,
    };
    const allSubscriptions = [];
    const subscriptions = subscription ? [subscription] : allSubscriptions;
    console.log('Send to ', subscriptions.length, ' users');
    await send(subscriptions, JSON.stringify(payload), options);
    return response(200, 'OK');
  } catch (error) {
    console.log(error);
    return response(500, 'ERROR');
  }
};

export const vapidPublicKey = async () => response(200, process.env.VAPID_PUBLIC_KEY);

export const register = async (event) => {
  const body = JSON.parse(event.body);
  const { subscription, userInfo } = body;
  console.log('allSubscriptions:', userInfo);
  return response(201, 'OK');
};
