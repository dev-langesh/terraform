const { extractUsersFromTfState } = require("./extractUsersFromTfState");
const { getMailedUsers } = require("./aws/dynamodb/getMailedUsers");

async function filterUsersToSendEmail() {
  const users = extractUsersFromTfState();

  console.log(users);

  const emailedUsers = await getMailedUsers();

  console.log(emailedUsers);

  const filteredUsers = users.filter(
    (user) => !emailedUsers.includes(user.name)
  );

  console.log(filteredUsers);

  return filteredUsers;
}

module.exports = { filterUsersToSendEmail };
