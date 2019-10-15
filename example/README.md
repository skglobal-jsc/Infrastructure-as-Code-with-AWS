# Full Stack Serverless with AWS demonstration

Still don't know how to start from [Starter](https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/tree/master/starter), don't worry please clone this repo and start to discovery how to use the base package.

```sh
# Create a new project
$ svn export https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/trunk/exmple your-project-name

# Change into the newly created directory
$ cd your-project-name
```

## Demonstration Features 
> Version 1.0

|Functions|Backend - NodeJS|Frontend - VueJS|Mobile - Flutter|
|:--|:-:|:-:|:-:|
|Sign In with Account, SNS|Amazon Cognito|amplify-js|amazon-cognito-identity-dart|
|Sign Up with Account|Amazon Cognito|amplify-js|amazon-cognito-identity-dart|
|Sign Out|Amazon Cognito|amplify-js|amazon-cognito-identity-dart|
|Account photo update|Amazon S3|amplify-js|http post|
|User list|Amazon Appsync|amplify-js|graphql|
|User list realtime update|Amazon Appsync|amplify-js|
|User delete|Amazon Appsync|amplify-js|graphql|
|User say hello|AWS Alambda|http post|http post
|Push Notification|Amazon SNS|||
|Report function|Amazon Pinpoint|amplify-js||
|Tracing|Amazon X-Ray|||
|Alarm|Amazon CloudWatch|||


## Source folders

**_Backend_**

Seed come from [Starter](https://github.com/skglobal-jsc/Infrastructure-as-Code-with-AWS/tree/master/starter) package, this your NodeJS backend with full of biz logic code described above.

**_Frontend_**
	
Web application using VueJS framework and amplify-js library for play with AWS service.

**_Mobile_**

Mobile application using cross platform Mobile framework - Flutter. Currently AWD Amplify library have not supported for Flutter yet but we worked around with another 3rd party with some tweak = ).
