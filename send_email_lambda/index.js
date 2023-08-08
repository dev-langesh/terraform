const { getobjet } = require("./lib/getObject");
const fs = require("fs");
const path = require("path");
const { sendEmail } = require("./lib/sendEmail");

require("dotenv").config();

async function handler() {
  await getobjet();
  const localFilePath = path.join("/tmp", "users.json");
  const jsonState = fs.readFileSync(localFilePath, "utf-8");

  const state = JSON.parse(jsonState);

  const loginProfile = state.resources.filter(
    (resource) => resource.type === "aws_iam_user_login_profile"
  );

  const users = loginProfile[0].instances.map((instance) => {
    return { name: instance.index_key, password: instance.attributes.password };
  });

  users.forEach((user) => {
    sendEmail(user.name, user.password);
  });
}

// handler();

module.exports = { handler };
