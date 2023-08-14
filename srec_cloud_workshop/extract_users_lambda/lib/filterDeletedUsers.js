const { extractUsersFromTfState } = require("./extractUsersFromTfState");
const { getMailedUsers } = require("./aws/dynamodb/getMailedUsers");

async function filterDeletedUsers() {
  const users = extractUsersFromTfState();

  const emails = users.map((user) => user.name);

  //   console.log("emails extracted form tf", emails);

  const emailedUsers = await getMailedUsers();

  //   console.log("from db", emailedUsers);

  const filteredUsers = emailedUsers.filter(
    (emailedUser) => !emails.includes(emailedUser)
  );

  console.log("deleted", filteredUsers);

  return filteredUsers;
}

module.exports = { filterDeletedUsers };
