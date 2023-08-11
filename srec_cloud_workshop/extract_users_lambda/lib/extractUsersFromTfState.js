const fs = require("fs");
const path = require("path");

function extractUsersFromTfState() {
  const tfStateFilePath = path.join("/tmp", "tfState.json");

  const jsonState = fs.readFileSync(tfStateFilePath, "utf-8");

  const state = JSON.parse(jsonState);

  const loginProfile = state.resources.filter(
    (resource) => resource.type === "aws_iam_user_login_profile"
  );

  const users = loginProfile[0].instances.map((instance) => {
    return {
      name: instance.index_key,
      password: instance.attributes.password,
    };
  });

  return users;
}

module.exports = { extractUsersFromTfState };
