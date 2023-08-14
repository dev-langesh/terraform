const { filterUsersToSendEmail } = require("./lib/filterUsersToSendEmail");
const { getobjet } = require("./lib/aws/s3/getObject");
const { sendEmail } = require("./lib/sendEmail");
const {
  updateEmailToDynamodb,
} = require("./lib/aws/dynamodb/updateEmailToDynamodb");
const { filterDeletedUsers } = require("./lib/filterDeletedUsers");
const { removeDeletedUsers } = require("./lib/aws/dynamodb/removeDeletedUsers");

async function handler() {
  await getobjet();

  const deletedUsers = await filterDeletedUsers();

  removeDeletedUsers(deletedUsers);

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
