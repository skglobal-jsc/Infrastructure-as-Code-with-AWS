/* eslint-disable class-methods-use-this */
import CognitoIdentityServiceProvider from 'aws-sdk/clients/cognitoidentityserviceprovider';

const serviceProvider = new CognitoIdentityServiceProvider({
  appVersion: '2016-04-18',
});
const UserPoolId = process.env.USER_POOL_ID;

export default class CognitoAPI {
  async createUser(data) {
    const { userName, email } = data;
    const params = {
      UserPoolId,
      Username: userName,
      DesiredDeliveryMediums: ['EMAIL'],
      UserAttributes: [
        {
          Name: 'email',
          Value: email,
        },
        {
          Name: 'email_verified',
          Value: 'true',
        },
      ],
    };
    const res = await serviceProvider.adminCreateUser(params).promise();
    return res.User;
  }

  async listUsers(data = {}) {
    const { filter: Filter, limit: Limit, nextToken } = data;
    const params = {
      UserPoolId,
      ...(Filter && { Filter }),
      ...(Limit && { Limit }),
      ...(nextToken && { PaginationToken: nextToken }),
    };
    const result = await serviceProvider.listUsers(params).promise();
    return {
      items: result.Users,
      ...(result.PaginationToken && { nextToken: result.PaginationToken }),
    };
  }

  async deleteUser(Username) {
    const params = {
      UserPoolId,
      Username,
    };
    const res = await serviceProvider.adminDeleteUser(params).promise();
    return res;
  }

  async listGroups(data = {}) {
    const { limit: Limit, nextToken } = data;
    const params = {
      UserPoolId,
      ...(Limit && { Limit }),
      ...(nextToken && { NextToken: nextToken }),
    };
    const result = await serviceProvider.listGroups(params).promise();
    return {
      items: result.Groups,
      ...(result.NextToken && { nextToken: result.NextToken }),
    };
  }

  async adminListGroupsForUser(Username) {
    const params = {
      UserPoolId,
      Username,
    };
    const result = await serviceProvider.adminListGroupsForUser(params).promise();
    return result.Groups;
  }
}
