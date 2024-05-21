import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import * as OneSignal from "https://esm.sh/@onesignal/node-onesignal@1.0.0-beta7";
import { createClient } from "npm:@supabase/supabase-js@2";

console.log("Starting server");
const _OnesignalAppId_ = Deno.env.get("ONESIGNAL_APP_ID")!;
const _OnesignalRestApiKey_ = Deno.env.get("ONESIGNAL_REST_API_KEY")!;
const configuration = OneSignal.createConfiguration({
  appKey: _OnesignalRestApiKey_,
});

const onesignal = new OneSignal.DefaultApi(configuration);

interface Notification {
  id: string;
  user_id: string;
  taskId: string;
  scheduledAt: Date;
  delivered: boolean;
  message: string;
  title: string;
}

interface WebhookPayload {
  type: "INSERT";
  table: string;
  record: Notification;
  schema: "public";
}

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

serve(async (req) => {
  const payload: WebhookPayload = await req.json();
  console.info("Received payload", payload);

  console.info("Creating OneSignal notification");

  console.log("Sending notification to user", payload.record.user_id);

  try {
    console.info("Creating OneSignal notification");
    const notification = new OneSignal.Notification();
    notification.app_id = _OnesignalAppId_;
    notification.include_external_user_ids = [payload.record.user_id];
    notification.send_after = payload.record.scheduledAt.toString();
    notification.contents = {
      en: payload.record.message,
    };
    notification.headings = {
      en: payload.record.title,
    };
    const onesignalApiRes = await onesignal.createNotification(notification);

    console.log(onesignalApiRes);

    // Update the record in the database
    const { error } = await supabase
      .from("scheduled_notifications")
      .update({ delivered: true })
      .eq("id", payload.record.id);

    if (error) {
      throw error;
    }

    return new Response(
      JSON.stringify({ onesignalResponse: onesignalApiRes }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  } catch (err) {
    console.error("Failed to create OneSignal notification", err);
    return new Response("Server error.", {
      headers: { "Content-Type": "application/json" },
      status: 400,
    });
  }
});
