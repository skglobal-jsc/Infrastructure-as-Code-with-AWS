/* eslint-disable no-return-await */
/* eslint-disable no-unused-vars */
import CognitoAPI from './cognito';

const cognitoApi = new CognitoAPI();

const resolvers = {
  Mutation: {
    createUser: ctx => cognitoApi.createUser(ctx.arguments.input),
    deleteUser: async (ctx) => {
      const { userName } = ctx.arguments;
      const result = await cognitoApi.deleteUser(userName);
      return (
        result && {
          Username: userName,
        }
      );
    },
  },
  Query: {
    allGroups: ctx => cognitoApi.listGroups(ctx.arguments),
    allUsers: (ctx) => {
      const { filter } = ctx.arguments;
      // build filter param
      let where;
      if (filter) {
        const { Name, Value, Type } = filter;

        const type = Type === 'EXTRACTLY' ? '=' : '^=';
        // eslint-disable-next-line no-useless-escape
        where = `${Name} ${type} \"${Value}\"`;
      }
      return cognitoApi.listUsers({ ...ctx.arguments, filter: where });
    },

    // fields resolvers
    userGroup: async (ctx) => {
      const { Username } = ctx.source;
      console.log('Calling userGroup', JSON.stringify(ctx.source));
      return await cognitoApi.adminListGroupsForUser(Username);
    },
  },
};

exports.main = async (event) => {
  const typeHandler = resolvers[event.typeName];
  if (typeHandler) {
    const resolver = typeHandler[event.fieldName];
    if (resolver) {
      // eslint-disable-next-line no-return-await
      try {
        return await resolver(event);
      } catch (error) {
        console.log(error);
        throw error;
      }
    }
  }
  throw new Error('Resolver not found.');
};
