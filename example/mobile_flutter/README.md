# mobile_base with AWS infrastructure

SPECIFICATION

- [ ] Identity
    - [ ] SignIn / SignUp
    - [x] Facebook SignUp
    - [x] Google SignUp
    - [x] SignOut
- [x] GraphQL
    - [x] User List
- [x] Restful API
    - [x] Hello All
- [ ] PinPoint (TBD)
    - [ ] Report event
- [ ] Push Notification
    - [ ] Show Alert
- [x] Upload files
    - [x] Change Avatar

TODO LIST

Milestone 1

1. Facebook SignUp
2. Google SignUp
3. SignOut
4. List - Account info

Milestone 2

1. List - Account info - Update Photo
1. Hello All - Restful

Milestone 3

1. User list - GraphQL

Milestone 4

1. User list - GraphQL - Mutation

Milestone 5

1. Push Notification - Show Alert

## Getting Started

Create secret.dart file in `lib/entries` folder, with content:

```dart
import 'package:amazon_cognito_identity_dart/cognito.dart';

const String apiEndpoint = 'xxxxxxxxx.execute-api.region.amazonaws.com';
const String graphqlUrl = 'https://xxxxxxxxxxxxxxxxxxxxxxxxxx.appsync-api.region.amazonaws.com/graphql';

AuthenticationSNSDetails snsDetails = AuthenticationSNSDetails(
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
```
