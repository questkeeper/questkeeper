import {
  Client,
  Databases,
  ID,
  Messaging,
  Models,
  Users,
} from "https://deno.land/x/appwrite@10.0.0/mod.ts";

// deno-lint-ignore no-explicit-any
export default async ({ req, res, log, error }: any) => {
  log(Deno.env);
  const client = new Client()
    .setEndpoint(Deno.env.get("APPWRITE_ENDPOINT")!)
    .setProject(Deno.env.get("APPWRITE_PROJECT_ID")!)
    .setKey(Deno.env.get("APPWRITE_API_KEY")!);

  const messaging = new Messaging(client);
  const users = new Users(client);
  const database = new Databases(client);

  const assignment = req.body as Assignment;
  log(assignment);
  const userId = assignment.$permissions[0].split(":")[1].slice(0, -2);

  const userTargets = await users.listTargets(userId);
  const targetArray = userTargets.targets.map((target) => target.$id);

  const notifications = assignment?.notifications;
  const notificationTimes = notifications.map((notification) =>
    notification.notificationTime
  );

  const timeRemaining = [12, 24, 48];
  let idx = 0;

  try {
    for (const time of notificationTimes) {
      log(time);
      const pushNotif = await messaging.createPush(
        ID.unique(),
        "Upcoming Assignment",
        `${assignment.title} is due in ${timeRemaining[idx]} hours.`,
        [],
        [userId],
        targetArray,
        {},
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        time,
      );

      await database.updateDocument(
        "public",
        "notifications",
        notifications[idx].$id,
        {
          "notificationId": pushNotif.$id,
        },
      );

      idx = idx++;
    }

    return res.empty();
  } catch (err) {
    error(err);
  }
};

type Assignment = Models.Document & {
  title: string;
  dueDate: Date;
  description: string;
  completed: boolean;
  starred: boolean;
  categories: string[];
  subtasks: string[];
  $permissions: string[];
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
  "$id": string;
};
