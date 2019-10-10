# Infrastructure as Code with AWS

At [SK-Global](https://sk-global.biz/) we have change to work with projects using different frameworks and infrastructures, and we paid a lot of time to try building a source code Base which can help us to have quick starting for building next projects. And that's point is important to us because we have to delivery our product to the market as quick as possible and can continue work with the source code after that without refactor debt. 

So we have [motivation](https://medium.com/sk-geek/adopting-the-base-sbp-at-skg-why-we-move-to-microservices-4461f984a72e) and decided to build our first base package with below characteristics:

_Web Service Infrastructure_

* Amazon Web Service - have strong experience.
* Serverless - function as a Service, no traffic no payment.
* Concentrate - rely on 100% AWS features without another third party services.

_Deployment_

*  Infrastructure as Code - easy to setup new project with multi environments, one click to deploy.
*  Security - all config store in AWS System Manager.

## Structure of Package

> This source code package is based on AWS serverless architecture so you need basic knowledge about [AWS CloudFormation](https://aws.amazon.com/cloudformation) and [Serverless framework](https://serverless.com/) for development and coding.

### Starter

This is a starting point for the project, it contain ready to go NodeJS backend framework with skeleton of AWS services.

* Amazon Cognito
* Amazon API Gateway
* Amazon Lambda
* Amazon S3
* Amazon Appsync
* Amazon DynamoDB
* Amazon SNS
* Amazon SES
* Amazon Pinpoint
* Amazon X-Ray
* Amazon CloudWatch

Please refer [this guide]() for step by step setup.

### Example

This is demonstration for basic features required for almost project which are:

+ Authentication
+ GraphQL
+ Restful API
+ Notification
+ Storage
+ Analytics
+ Alarm
+ Trace

Please refer [this folder]() to deep dive into example.

---
This package base is a fully open source project, and we welcome contributions. We hope this package can be a good starting point to build a great product. Happy coding!
