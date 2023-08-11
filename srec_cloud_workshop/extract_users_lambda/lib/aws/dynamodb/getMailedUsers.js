const { ScanCommand } = require("@aws-sdk/client-dynamodb");
const { dynamodbClient } = require("./dynamodbClient");

async function getMailedUsers() {
  const tableName = "iam_users";

  const scanParams = {
    TableName: tableName,
    ProjectionExpression: "email",
  };

  const scanCommand = new ScanCommand(scanParams);

  const scanResponse = await dynamodbClient.send(scanCommand);
  const emails = scanResponse.Items.map((item) => item.email.S);
  console.log("Emails:", emails);
  return emails;
}

module.exports = { getMailedUsers };
