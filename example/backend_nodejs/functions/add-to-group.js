import CognitoIdentityServiceProvider from 'aws-sdk/clients/cognitoidentityserviceprovider';

const cognitoidentityserviceprovider = new CognitoIdentityServiceProvider({
  appVersion: '2016-04-18',
});

export async function handler(event, _context, callback) {
  const groupParams = {
    GroupName: process.env.GROUP,
    UserPoolId: event.userPoolId,
  };

  const addUserParams = {
    GroupName: process.env.GROUP,
    UserPoolId: event.userPoolId,
    Username: event.userName,
  };

  console.log('groupParams:', groupParams);
  await cognitoidentityserviceprovider.getGroup(groupParams, async (err) => {
    if (err) {
      console.log('getGroup err:');
      await cognitoidentityserviceprovider.createGroup(groupParams).promise();
    }
  }).promise();
  console.log('adminAddUserToGroup:', addUserParams);

  cognitoidentityserviceprovider.adminAddUserToGroup(addUserParams, (err) => {
    if (err) {
      callback(err);
    }
    callback(null, event);
  });
}
