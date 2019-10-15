// import Auth from '@aws-amplify/auth'
const awsmobile = {
  aws_project_region: 'ap-southeast-2',
  aws_cognito_identity_pool_id: 'ap-southeast-2:eee49be2-29ce-40d0-864d-efa195450517',
  aws_cognito_region: 'ap-southeast-2',
  aws_user_pools_id: 'ap-southeast-2_uoAPs7a1H',
  aws_user_pools_web_client_id: '5cle39cuj8a1uoccbi9614f12g',
  oauth: {
    domain: 'skg-base-dev.auth.ap-southeast-2.amazoncognito.com',
    scope: ['phone', 'email', 'openid', 'profile', 'aws.cognito.signin.user.admin'],
    redirectSignIn: 'http://localhost:3000/user/signed-in/',
    redirectSignOut: 'http://localhost:3000/',
    responseType: 'code'
  },
  federationTarget: 'COGNITO_USER_POOLS',
  aws_mobile_analytics_app_id: '3ed6b78c5a3042b682feae4d1b05afc6',
  aws_mobile_analytics_app_region: 'ap-southeast-2',
  aws_user_files_s3_bucket: 'skg-dev-s3bucket-mbz2y336iyll',
  aws_user_files_s3_bucket_region: 'ap-southeast-2',
  Storage: {
    AWSS3: {
      bucket: 'skg-dev-s3bucket-mbz2y336iyll', // REQUIRED -  Amazon S3 bucket
      region: 'ap-southeast-2' // OPTIONAL -  Amazon service region
    }
  }
}

export default awsmobile
