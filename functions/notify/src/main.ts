import {
  Client,
  Messaging,
  Users,
  Databases,
  type Models,
  ID,
  type Permission,
} from "node-appwrite";

type Assignment = Models.Document & {
  title: string;
  dueDate: Date;
  description: string;
  completed: boolean;
  starred: boolean;
  categories: string[];
  subtasks: string[];
  $permissions: Permission[];
  $createdAt: Date;
  $updatedAt: Date;
  $databaseId: string;
  $collectionId: string;
  $id: string;
  notifications: Notification[];
};

type Notification = {
  notificationTime: string;
  activated: boolean;
  notificationId?: string;
  $id: string;
};

export default async ({ req, res, error, log }: any) => {
  const client = new Client()
    .setEndpoint("https://cloud.appwrite.io/v1")
    .setProject(Bun.env["APPWRITE_FUNCTION_PROJECT_ID"] as string)
    .setKey(Bun.env["APPWRITE_API_KEY"] as string);

  const jsonBody = req.body;

  const assignment = jsonBody["assignment"] as Assignment;
  const type = jsonBody["type"] as string;

  const messaging = new Messaging(client);
  const users = new Users(client);
  const database = new Databases(client);

  const userId = assignment.$permissions[0].split(":")[1].slice(0, -2);

  if (!assignment) {
    error("Assignment not found", req.body);
    return res.json({ message: "Resource not found.", status: 404 });
  }

  // Fetch user targets
  const targets = (await users.listTargets(userId)).targets
    .map((target) => {
      if (target.providerType === "push") {
        return target.$id;
      }

      return "";
    })
    .filter((target) => target !== "");

  try {
    log("Creating test push");
    const test = await messaging.createPush(
      ID.unique(),
      "Test",
      "Test",
      [],
      [userId],
      targets,
      {},
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      false
    );
    log(test);
  } catch (err) {
    error(err);
  }

  switch (type) {
    case "create":
      createPush(assignment, userId, targets, messaging, database, log, error);
      break;
    case "update":
      updatePush(assignment, userId, targets, messaging, database, log, error);
      break;
    case "delete":
      deletePush(assignment, userId, targets, messaging, database, log, error);
      break;
    default:
      error(`Achievement: How did we get here? ${type}`);
      return res.json({ message: "Error" });
  }

  return res.json({ message: "Success" });
};

async function createPush(
  assignment: Assignment,
  userId: string,
  targets: string[],
  messaging: Messaging,
  database: Databases,
  log: any,
  error: any
) {
  const notifications = assignment?.notifications;
  const notificationTimes = notifications.map(
    (notification) => notification.notificationTime
  );

  const timeRemaining = [12, 24, 48];
  let idx = 0;

  try {
    for (const time of notificationTimes) {
      log("Test Push");

      const pushNotif = await messaging.createPush(
        ID.unique(),
        assignment.title,
        `is due in ${timeRemaining[idx]} hours.`,
        [],
        [userId],
        targets,
        {},
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        false,
        time
      );
      log("Push Notification");
      log(pushNotif);

      await database.updateDocument(
        "public",
        "notifications",
        notifications[idx].$id,
        {
          notificationId: pushNotif?.$id,
          activated: true,
        }
      );

      idx = idx++;
    }
  } catch (err) {
    error(err);
  }

  return {
    message: "Success",
    notificationTimes,
  };
}

async function updatePush(
  assignment: Assignment,
  userId: string,
  targets: string[],
  messaging: Messaging,
  database: Databases,
  log: any,
  error: any
) {
  const notifications = assignment?.notifications;
  const notificationTimes = notifications.map(
    (notification) => notification.notificationTime
  );

  const timeRemaining = [12, 24, 48];
  let idx = 0;

  try {
    log("Deleting old notifications");
    for (const notification of notifications) {
      await messaging.delete(notification.notificationId as string);
    }
  } catch (err) {
    error(err);
  }

  try {
    for (const time of notificationTimes) {
      log(time);
      const pushNotif = await messaging.createPush(
        ID.unique(),
        "Upcoming Assignment",
        `${assignment.title} is due in ${timeRemaining[idx]} hours.`,
        [],
        [userId],
        targets,
        {},
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        time
      );

      await database.updateDocument(
        "public",
        "notifications",
        notifications[idx].$id,
        {
          notificationId: pushNotif.$id,
        }
      );

      idx = idx++;
    }

    return {
      message: "Success",
      notificationTimes,
    };
  } catch (err) {
    error(err);
  }
}

async function deletePush(
  assignment: Assignment,
  userId: string,
  targets: string[],
  messaging: Messaging,
  database: Databases,
  log: any,
  error: any
) {
  const notifications = assignment?.notifications;
  try {
    log("Deleting old notifications");
    for (const notification of notifications) {
      await messaging.delete(notification.notificationId as string);

      await database.deleteDocument(
        "public",
        "notifications",
        notification.$id
      );
    }
  } catch (err) {
    error(err);
  }
}
