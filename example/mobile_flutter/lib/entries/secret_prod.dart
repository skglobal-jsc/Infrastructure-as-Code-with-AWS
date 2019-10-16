import 'package:amazon_cognito_identity_dart/cognito.dart';

const String apiEndpoint = '';

final AuthenticationSNSDetails snsDetails = AuthenticationSNSDetails(
  region: "ap-southeast-1",
  userPoolDomainPrefix: "lazaha-dev",
  userPoolId: "ap-southeast-1_heuHGdXIe",
  userPoolAppClientId: "5jp5ho49hc7agh1bfc84714drg",
  userPoolAppClientSecret: '9cq5mu34ms670ev5g48rmmalnpluk4pc6vlrfn473tmje14j9po',
  identityPoolId: "ap-southeast-1:b878af18-86cc-4570-8293-b90159a931de",
  cognitoIdentityPoolUrl: "https://cognito-identity.ap-southeast-1.amazonaws.com",
  cognitoUserPoolLoginRedirectUrl: "skg://aws_demo",
  cognitoUserPoolLogoutRedirectUrl: "skg://aws_demo",
  cognitoUserPoolLoginScopes: "phone email openid profile aws.cognito.signin.user.admin",
);
