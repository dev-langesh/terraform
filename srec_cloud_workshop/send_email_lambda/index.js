const { extractUsers } = require("./lib/extractUsers");
const { getobjet } = require("./lib/getObject");

const { sendEmail } = require("./lib/sendEmail");

require("dotenv").config();

async function handler() {
  await getobjet();

  const users = extractUsers();

  for (const user of users) {
    const email = user.name;
    const password = user.password;

    const response = await sendEmail(email, password);

    return {
      statusCode: 200,
      body: JSON.stringify({
        input: response,
      }),
    };
  }
}

module.exports = { handler };
