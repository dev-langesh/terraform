const { extractUsersFromTfState } = require("./extractUsersFromTfState");
const { getMailedUsers } = require("./aws/dynamodb/getMailedUsers");

async function filterUsersToSendEmail() {
  const users = extractUsersFromTfState();

  console.log("from tfstate", users);

  const emailedUsers = await getMailedUsers();

  console.log("from db", emailedUsers);

  const filteredUsers = users.filter(
    (user) => !emailedUsers.includes(user.name)
  );

  console.log("send email", filteredUsers);

  return filteredUsers;
}

module.exports = { filterUsersToSendEmail };
