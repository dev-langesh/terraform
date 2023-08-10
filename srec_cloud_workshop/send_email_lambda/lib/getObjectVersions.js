const { ListObjectVersionsCommand } = require("@aws-sdk/client-s3");
const { s3Client } = require("./s3Client");

async function getObjectVersions(params) {
  const versions = await s3Client.send(new ListObjectVersionsCommand(params));

  return versions;
}

module.exports = { getObjectVersions };
