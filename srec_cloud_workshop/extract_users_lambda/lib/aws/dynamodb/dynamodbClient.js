const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");

const dynamodbClient = new DynamoDBClient({
  region: "ap-south-1",
  apiVersion: "latest",
});

module.exports = { dynamodbClient };
