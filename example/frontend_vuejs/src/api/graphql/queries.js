export const allUsers = `query AllUsers(
  $limit: Int
  $nextToken: String
) {
  allUsers(
    limit: $limit
    nextToken: $nextToken
  ) {
    items {
      Enabled
      UserStatus
      Username
      Attributes {
        Name
        Value
      }
      groups {
        GroupName
      }
    },
    nextToken
  }
}`
