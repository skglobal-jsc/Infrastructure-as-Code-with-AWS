export const deleteUser = `mutation DeleteUser($userName: String!) {
  deleteUser(userName: $userName) {
    Username
  }
}
`
