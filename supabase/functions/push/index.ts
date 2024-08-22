import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL") as string;
const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") as string;
const supabase = createClient(supabaseUrl, supabaseKey);

const apiEndpointUrl = Deno.env.get("API_ENDPOINT") as string;
const apiServerKey = Deno.env.get("API_SERVER_KEY") as string;

async function sendFCMNotificationToGroup(
  notification: unknown,
) {
  const response = await fetch(
    `${apiEndpointUrl}/send`,
    {
      method: "POST",
      headers: {
        "X-API-KEY": apiServerKey,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        notification,
      }),
    },
  );

  if (!response.ok) {
    throw new Error(`Failed to send notification: ${response.statusText}`);
  }

  return await response.json();
}

Deno.serve(async (_: Request) => {
  const nowUTC = new Date().toUTCString();
  // Convert "nowUTC" to closest minute floor

  // Get the current minute and convert it back to iso string
  const minTime = new Date(new Date(nowUTC).setSeconds(0, 0)).toISOString();
  const maxTime = new Date(new Date(nowUTC).setSeconds(59, 999)).toISOString();

  const { data: notifications, error } = await supabase
    .from("notification_schedule")
    .select("*")
    .gte("scheduled_at", minTime)
    .lte("scheduled_at", maxTime)
    .order("scheduled_at");

  if (error) {
    console.error("Error fetching notifications:", error);
    return new Response(
      JSON.stringify({
        error: "Failed to fetch notifications",
        message: error.message,
      }),
      { status: 500 },
    );
  }

  const results = [];

  for (const notification of notifications) {
    try {
      // Send FCM notification to the user's device group
      await sendFCMNotificationToGroup(
        notification,
      );

      // Delete the sent notification
      const { error } = await supabase
        .from("notification_schedule")
        .update({ sent: true, sent_at: nowUTC })
        .eq("id", notification.id);

      if (error) {
        throw new Error(`Failed to delete notification ${notification.id}`);
      }

      results.push({ id: notification.id, status: "sent" });
    } catch (error) {
      console.error(`Error processing notification ${notification.id}:`, error);
      results.push({
        id: notification.id,
        status: "failed",
        error: error.message,
      });
    }
  }

  return new Response(
    JSON.stringify({ message: "Notifications processed", results }),
    { headers: { "Content-Type": "application/json" } },
  );
});
