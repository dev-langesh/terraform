const { GetObjectCommand } = require("@aws-sdk/client-s3");
const { s3Client } = require("./s3Client");
const fs = require("fs");
const path = require("path");

async function getobjet() {
  const bucketName = "langesh-terraform-state";
  const objectKey = "terraform.tfstate";

  const localFilePath = path.join("/tmp", "users.json");

  const params = {
    Bucket: bucketName,
    Key: objectKey,
  };

  const { Body } = await s3Client.send(new GetObjectCommand(params));

  await new Promise((resolve, reject) => {
    Body.pipe(fs.createWriteStream(localFilePath))
      .on("error", (err) => reject(err))
      .on("close", () => resolve());
  });
}

module.exports = { getobjet };
