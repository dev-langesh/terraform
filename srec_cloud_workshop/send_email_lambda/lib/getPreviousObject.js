const { GetObjectCommand } = require("@aws-sdk/client-s3");
const { s3Client } = require("./s3Client");
const fs = require("fs");
const path = require("path");

async function getPreviousObject(prevVersionId) {
  const prevFilePath = path.join("/tmp", "prev.json");

  const bucketName = "langesh-terraform-state";
  const objectKey = "terraform.tfstate";

  const params = {
    Bucket: bucketName,
    Key: objectKey,
  };

  const prevVersionParams = { ...params, VersionId: prevVersionId };

  const prevVersionObj = await s3Client.send(
    new GetObjectCommand(prevVersionParams)
  );

  await new Promise((resolve, reject) => {
    prevVersionObj.Body.pipe(fs.createWriteStream(prevFilePath))
      .on("error", (err) => reject(err))
      .on("close", () => resolve());
  });
}

module.exports = { getPreviousObject };
