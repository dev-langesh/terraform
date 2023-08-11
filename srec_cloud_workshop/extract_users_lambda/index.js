// const { extractUsers } = require("./lib/extractUsers");
const { getMailedUsers } = require("./lib/aws/dynamodb/getMailedUsers");
const { filterUsersToSendEmail } = require("./lib/filterUsersToSendEmail");
const { getobjet } = require("./lib/aws/s3/getObject");
const { extractUsersFromTfState } = require("./lib/extractUsersFromTfState");
const { sendEmail } = require("./lib/sendEmail");
const {
  updateEmailToDynamodb,
} = require("./lib/aws/dynamodb/updateEmailToDynamodb");

async function handler() {
  await getobjet();

  const users = await filterUsersToSendEmail();

  for (const user of users) {
    const email = user.name;
    const password = user.password;

    await sendEmail(email, password);

    updateEmailToDynamodb(email);
  }

  return {
    statusCode: 200,
  };
}

// handler();

module.exports = { handler };
