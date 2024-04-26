import {
  Client,
  Messaging,
  Models,
} from "https://deno.land/x/appwrite@10.0.0/mod.ts";

// deno-lint-ignore no-explicit-any
export default async ({ req, res, log, error }: any) => {
  const client = new Client()
    .setEndpoint(Deno.env.get("APPWRITE_ENDPOINT")!)
    .setProject(Deno.env.get("APPWRITE_PROJECT_ID")!)
    .setKey(Deno.env.get("APPWRITE_API_KEY")!);

  const messaging = new Messaging(client);

  const assignment = req.body as Assignment;
  log(assignment);

  const messagingIds = assignment?.notifications?.map((notification) =>
    notification.notificationId
  );

  try {
    for (const message of messagingIds) {
      await messaging.delete(message!);
    }
  } catch (e) {
    error(e);
  }

  return res.empty();
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
