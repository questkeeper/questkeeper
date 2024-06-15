import { createClient } from "npm:@supabase/supabase-js@2";
import { Novu } from "npm:@novu/node";

interface Notification {
  id: number;
  user_id: string;
  taskId: number;
  dueDate: string;
  delivered: boolean;
  message: string;
  title: string;
}

interface NotificationTransaction {
  id: number;
  notificationId: number;
  transactionId: number;
  scheduledAt: Date;
}

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: Notification;
  schema: "public";
  old_record: Notification | null;
}

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const novu = new Novu(Deno.env.get("NOVU_API_KEY")!);

Deno.serve(async (req) => {
  console.info("Received request", req);
  const webhookPayload: WebhookPayload = await req.json();
  console.info("Received payload", webhookPayload);
  const payload = webhookPayload.record;

  // TODO: Get the user's preferences for notification times
  // Current setup is temporary
  const times = [12, 24, 48];
  const sendAtArray = [];
  const transactionIds: string[] = [];

  let resData = {
    success: true,
    error: null,
    message: "Notification scheduled successfully",
  };

  const dueAt = new Date(payload.dueDate);

  try {
    for (let i = 0; i < times.length; i++) {
      const time = times[i];
      const sendAt = new Date(dueAt.getTime() - time * 60 * 60 * 1000);

      // Skip if the sendAt time is in the past
      if (sendAt < new Date()) {
        continue;
      }

      sendAtArray.push(sendAt);
      const transaction = await novu.trigger("schedulepush", {
        payload: {
          sendAt: sendAt.toISOString(),
          payload: {
            title: payload.title,
            message: payload.message,
          },
        },
        to: {
          subscriberId: payload.user_id,
        },
      });

      transactionIds.push(transaction.data.data.transactionId);
    }

    await supabase
      .from("notification_transactions")
      .insert(
        sendAtArray.map((sendAt) => ({
          notificationId: payload.id,
          scheduledAt: sendAt,
          transactionId: transactionIds.shift(),
        })),
      );
  } catch (error) {
    console.error(error);
    resData = {
      success: false,
      error: error,
      message: "Failed to schedule notification",
    };
  }

  return new Response(JSON.stringify(resData), {
    headers: { "Content-Type": "application/json" },
  });
});
