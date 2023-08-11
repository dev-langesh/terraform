const { PutItemCommand } = require("@aws-sdk/client-dynamodb");
const { dynamodbClient } = require("./dynamodbClient");

async function updateEmailToDynamodb(email) {
  // Specify the table name
  const tableName = "iam_users";

  // Specify the item you want to add
  const newItem = {
    email: { S: email },
    // ... other attributes
  };

  const putItemParams = {
    TableName: tableName,
    Item: newItem,
  };

  const putItemCommand = new PutItemCommand(putItemParams);

  try {
    await dynamodbClient.send(putItemCommand);
    console.log("Item added successfully");
  } catch (error) {
    console.error("Error adding item:", error);
  }
}

module.exports = { updateEmailToDynamodb };
