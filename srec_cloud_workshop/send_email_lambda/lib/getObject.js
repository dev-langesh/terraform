const {
  GetObjectCommand,
  ListObjectVersionsCommand,
} = require("@aws-sdk/client-s3");
const { s3Client } = require("./s3Client");
const fs = require("fs");
const path = require("path");

async function getobjet() {
  const bucketName = "langesh-terraform-state";
  const objectKey = "terraform.tfstate";

  const currentFilePath = path.join("/tmp", "current.json");
  const prevFilePath = path.join("/tmp", "prev.json");

  const params = {
    Bucket: bucketName,
    Key: objectKey,
  };

  const versions = await s3Client.send(new ListObjectVersionsCommand(params));

  const prevVersionId = versions.Versions[1].VersionId;

  console.log(prevVersionId);

  const currentVersionObj = await s3Client.send(new GetObjectCommand(params));

  const prevVersionParams = { ...params, VersionId: prevVersionId };

  const prevVersionObj = await s3Client.send(
    new GetObjectCommand(prevVersionParams)
  );

  await new Promise((resolve, reject) => {
    currentVersionObj.Body.pipe(fs.createWriteStream(currentFilePath))
      .on("error", (err) => reject(err))
      .on("close", () => resolve());
  });

  await new Promise((resolve, reject) => {
    prevVersionObj.Body.pipe(fs.createWriteStream(prevFilePath))
      .on("error", (err) => reject(err))
      .on("close", () => resolve());
  });
}

module.exports = { getobjet };
