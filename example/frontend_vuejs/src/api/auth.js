import Auth from '@aws-amplify/auth'

// TODO: get from cokkie in case server
export async function getInfo (bypassCache = false) {
  try {
    const user = await Auth.currentAuthenticatedUser({ bypassCache })
    const { attributes, username, signInUserSession: { idToken: token } } = user
    const groups = token.payload['cognito:groups'] || []
    const idToken = token.jwtToken
    return {
      attributes,
      username,
      groups,
      idToken
    }
  } catch (e) {
    return null
  }
}

export async function logout () {
  await Auth.signOut()
}
