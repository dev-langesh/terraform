const {
  GetObjectCommand,
  ListObjectVersionsCommand,
} = require("@aws-sdk/client-s3");
const { s3Client } = require("./s3Client");
const fs = require("fs");
const path = require("path");
const { getPreviousObject } = require("./getPreviousObject");
const { getObjectVersions } = require("./getObjectVersions");

async function getobjet() {
  const bucketName = "langesh-terraform-state";
  const objectKey = "terraform.tfstate";

  const currentFilePath = path.join("/tmp", "current.json");

  const params = {
    Bucket: bucketName,
    Key: objectKey,
  };

  const versions = await getObjectVersions(params);

  const currentVersionObj = await s3Client.send(new GetObjectCommand(params));

  await new Promise((resolve, reject) => {
    currentVersionObj.Body.pipe(fs.createWriteStream(currentFilePath))
      .on("error", (err) => reject(err))
      .on("close", () => resolve());
  });

  if (versions.Versions.length > 1) {
    const prevVersionId = versions.Versions[1].VersionId;

    getPreviousObject(prevVersionId);
  }
}

module.exports = { getobjet };
