# Full Stack Serverless with AWS demonstration

Demonstrate for [Serverless-Stack-with-NodeJS-AWS](https://github.com/skglobal-jsc/Serverless-Stack-with-NodeJS-AWS)

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

## Server Architecture
![](../raw/example_architecture.png)

## Source Structure

### [Backend]()
The starter seed come from [Serverless Stack with NodeJS & AWS]() package. We added some necessary plugins and logic code. In this demo project we didn't demonstrate Database implementation because we think it's too much for the demo.

### [Frontend]()
We selected VueJS as frontend framework for demonstration and use amplify-js library for play with AWS service.

### [Mobile]()
We selected Flutter as cross platform mobile framework for demonstration. Currently AWD Amplify library haven't supported for Flutter yet but we worked around with another 3rd party with some tweak = ).
