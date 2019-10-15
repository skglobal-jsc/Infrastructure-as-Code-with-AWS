# SKG Base Serverless Node.js

A Serverless starter that adds ES7 syntax, serverless-offline, environment variables, and unit test support.

SKG Base uses the [serverless-webpack](https://github.com/serverless-heaven/serverless-webpack) plugin, [Babel](https://babeljs.io), [serverless-offline](https://github.com/dherault/serverless-offline), and [Jest](https://facebook.github.io/jest/). It supports:

- **ES7 syntax in your handler functions**
  - Use `import` and `export`
- **Package your functions using Webpack**
- **Run API Gateway locally**
  - Use `serverless offline start`
- **Support for unit tests**
  - Run `yarn test` to run your tests
- **Sourcemaps for proper error messages**
  - Error message show the correct line numbers
  - Works in production with CloudWatch
- **Automatic support for multiple handler files**
  - No need to add a new entry to your `webpack.config.js`
- **Add environment variables for your stages**

---

### How to add FB, google
Now you must do it by manual. Cloudformation is not suported now.
1. Config User pool domain

  - App integration/ Domain
  - Federation/Identity providers
  - App integration/ App client settings
  https://<your-user-pool-domain>/oauth2/idpresponse
  https://skg-base.auth.ap-southeast-1.amazoncognito.com/oauth2/idpresponse

```https://your_domain/login?response_type=code&client_id=your_app_client_id&redirect_uri=your_callback_url```

  https://skg-base.auth.ap-southeast-1.amazoncognito.com/login?response_type=code&client_id=4bct3drsjvgi4pe0crit6mj436&redirect_uri=https://www.example.com/


2. Config

