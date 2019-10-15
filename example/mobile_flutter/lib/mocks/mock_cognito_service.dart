
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/foundation.dart';

import '../services/cognito_sns_service.dart';

class MockCognitoService extends BaseCognitoService {

  AuthenticationSNSDetails snsDetails = _MockAuthenticationSNSDetails(
    region: "ap-southeast-1",
    userPoolDomainPrefix: "abc-dev",
    userPoolId: "ap-southeast-1_xxxxxxxxx",
    userPoolAppClientId: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
    identityPoolId: "ap-southeast-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    cognitoIdentityPoolUrl: "https://cognito-identity.ap-southeast-1.amazonaws.com",
    cognitoUserPoolLoginRedirectUrl: "skg://aws_demo",
    cognitoUserPoolLogoutRedirectUrl: "skg://aws_demo",
    cognitoUserPoolLoginScopes: "phone email openid profile aws.cognito.signin.user.admin",
  );

  @override
  Future<AWSCredentials> get credentials => Future.value(AWSCredentials(
    'accessKeyId',
    'sessionToken',
    'secretAccessKey'
  ));

  @override
  String get email => 'abc@email.com';

  @override
  Future<String> get idToken => Future.value('idToken');
  @override
  Future<String> get accessToken => Future.value('accessToken');

  @override
  Future<bool> init() {
    return Future.value(true);
  }

  @override
  Future<void> signOut() {
    return null;
  }

  @override
  Future<bool> signUp(String code) {
    return Future.value(true);
  }

  @override
  updateAttributes(List<CognitoUserAttribute> attributes) {
    return null;
  }

  @override
  Future<Map<String, dynamic>> get userAttributes => Future.value({'avatar': 'assets/nothumb.png'});

  @override
  String get userName => 'MyUserName';

  @override
  Future<bool> login(AuthenticationDetails authen) {
    return Future.value(true);
  }

}

class _MockAuthenticationSNSDetails extends AuthenticationSNSDetails {
  final String region;
  final String userPoolDomainPrefix;
  final String userPoolId;
  final String userPoolAppClientId;
  final String userPoolAppClientSecret;
  final String identityPoolId;
  final String cognitoIdentityPoolUrl;
  final String cognitoUserPoolLoginRedirectUrl;
  final String cognitoUserPoolLogoutRedirectUrl;
  final String cognitoUserPoolLoginScopes;

  _MockAuthenticationSNSDetails({
    @required this.region,
    @required this.userPoolDomainPrefix,
    @required this.userPoolId,
    @required this.userPoolAppClientId,
    this.userPoolAppClientSecret,
    @required this.identityPoolId,
    @required this.cognitoIdentityPoolUrl,
    @required this.cognitoUserPoolLoginRedirectUrl,
    @required this.cognitoUserPoolLogoutRedirectUrl,
    @required this.cognitoUserPoolLoginScopes,
  });

  String get cognitoUserPoolLoginUrl =>'${this.cognitoUserPoolLoginRedirectUrl}/?code=1234';

  String get cognitoUserPoolLoginFacebookUrl =>'${this.cognitoUserPoolLoginRedirectUrl}/?code=1234';

  String get cognitoUserPoolLoginGoogleUrl =>'${this.cognitoUserPoolLoginRedirectUrl}/?code=1234';

  String get cognitoUserPoolLogoutUrl =>'';

  String get cognitoUserPoolTokenUrl =>'';

}
