import 'package:amazon_cognito_identity_dart/cognito.dart';

const String apiEndpoint = 'ecoius1zkj.execute-api.ap-southeast-2.amazonaws.com';
const String graphqlUrl = 'https://brtjse6knvhchnkjkfak5na7ca.appsync-api.ap-southeast-2.amazonaws.com/graphql';

final AuthenticationSNSDetails snsDetails = AuthenticationSNSDetails(
  region: "ap-southeast-2",
  userPoolDomainPrefix: "skg-base-dev",
  userPoolId: "ap-southeast-2_uoAPs7a1H",
  userPoolAppClientId: "1u4km2cl0cn71r25p661rs393c",
  userPoolAppClientSecret: '9cq5mu34ms670ev5g48rmmalnpluk4pc6vlrfn473tmje14j9po',
  identityPoolId: "ap-southeast-2:eee49be2-29ce-40d0-864d-efa195450517",
  cognitoIdentityPoolUrl: "https://cognito-identity.ap-southeast-1.amazonaws.com",
  cognitoUserPoolLoginRedirectUrl: "myapp://",
  cognitoUserPoolLogoutRedirectUrl: "myapp://",
  cognitoUserPoolLoginScopes: "phone email openid profile aws.cognito.signin.user.admin",
);
