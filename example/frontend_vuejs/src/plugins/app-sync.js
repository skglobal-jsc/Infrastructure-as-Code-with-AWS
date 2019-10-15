import Vue from "vue";
import AWSAppSyncClient, { AUTH_TYPE } from "aws-appsync";
import Auth from '@aws-amplify/auth'
import VueApollo from "vue-apollo";

import { defaultApp } from '@/config/app-sync'

const config = {
  url: defaultApp.ApiUrl,
  region: defaultApp.Region,
  auth: {
    type: AUTH_TYPE.AMAZON_COGNITO_USER_POOLS,
    jwtToken: async () => (await Auth.currentSession()).getIdToken().getJwtToken()
  },
  disableOffline: true
};

const options = {
  defaultOptions: {
    watchQuery: {
      fetchPolicy: "cache-and-network"
    }
  }
};

const defaultClient = new AWSAppSyncClient(config, options);

const apolloProvider = new VueApollo({ defaultClient });

Vue.use(VueApollo);

export default apolloProvider;

