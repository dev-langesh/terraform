const { BatchWriteItemCommand } = require("@aws-sdk/client-dynamodb");
const { dynamodbClient } = require("./dynamodbClient");

async function removeDeletedUsers(users) {
  // Specify the table name
  const tableName = "iam_users";

  if (users.length < 1) {
    return;
  }

  // Create DeleteRequest objects for each email
  const deleteRequests = users.map((email) => ({
    DeleteRequest: {
      Key: {
        email: { S: email },
      },
    },
  }));

  // Set up the BatchWriteItemCommand to delete the items
  const batchWriteParams = {
    RequestItems: {
      [tableName]: deleteRequests,
    },
  };

  const batchWriteCommand = new BatchWriteItemCommand(batchWriteParams);

  try {
    await dynamodbClient.send(batchWriteCommand);
    console.log("Items deleted successfully");
  } catch (error) {
    console.error("Error deleting items:", error);
  }
}

module.exports = { removeDeletedUsers };
