// const { extractUsers } = require("./lib/extractUsers");
const { getobjet } = require("./lib/aws/s3/getObject");
const { extractUsersFromTfState } = require("./lib/extractUsersFromTfState");

async function handler() {
  await getobjet();

  const users = extractUsersFromTfState();

  console.log(users);
}

handler();

module.exports = { handler };
