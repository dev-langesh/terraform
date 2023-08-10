const path = require("path");
const {
  extractUsersFromLoginProfile,
} = require("./extractUsersFromLoginProfile");

function extractUsers() {
  let currFilePath = path.join("/tmp", "current.json");
  let prevFilePath = path.join("/tmp", "prev.json");

  const currentUsers = extractUsersFromLoginProfile(currFilePath);
  const nonCurrentUsers = extractUsersFromLoginProfile(prevFilePath);

  const nonCurrentUserNameList = nonCurrentUsers.map((user) => user.name);

  const users = currentUsers.filter(
    (user) => !nonCurrentUserNameList.includes(user.name)
  );

  return users;
}

module.exports = { extractUsers };
