// deno-lint-ignore-file
import { createClient } from "npm:@supabase/supabase-js@2";
import { Novu, PushProviderIdEnum } from "npm:@novu/node";

interface Profile {
  deviceId: string;
  user_id: string;
  deviceName: string | null;
  token: string;
  previousToken: string | null;
  deviceType: "ios" | "android" | "web" | "macos" | "windows" | null;
}

type ProfileType = "INSERT" | "UPDATE" | "DELETE";

interface WebhookPayload {
  type: ProfileType;
  table: string;
  record: Profile;
  schema: "public";
  old_record: Profile | null;
}

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const novu = new Novu(Deno.env.get("NOVU_API_KEY")!);

Deno.serve(async (req) => {
  const webhookPayload: WebhookPayload = await req.json();
  const payload = webhookPayload.record;

  let subscribers: any;

  try {
    subscribers = await novu.subscribers.get(payload.user_id);
  } catch (error) {
    subscribers = { status: 404 };
  }

  if (shouldCreateNew(subscribers, payload)) {
    webhookPayload.type = "INSERT";
  }

  try {
    switch (webhookPayload.type) {
      case "INSERT":
        await addToSubscriberProfile(subscribers, payload);
        break;
      case "UPDATE":
        await updateSubscriberProfile(subscribers, payload);
        break;
      case "DELETE":
        await deleteDeviceFromSubscriberProfile(subscribers, payload);
        break;
    }
  } catch (error) {
    console.error(error);
    return new Response(
      JSON.stringify({
        success: false,
        status: 500,
        error: error.message,
      }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({
      success: true,
      status: 200,
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});

function shouldCreateNew(
  subscribers: any,
  payload: Profile,
) {
  return subscribers.status === 404 || payload.previousToken === null ||
    subscribers.data.channels.length === 0 ||
    !subscribers.data.channels[0].credentials.deviceTokens.includes(
      payload.token,
    );
}

async function deleteDeviceFromSubscriberProfile(
  subscribers: any,
  payload: Profile,
) {
  if (payload.previousToken === null) {
    throw new Error("Previous token is required for delete operation");
  }
  await novu.subscribers.update(payload.user_id, {
    channels: [
      {
        "credentials": {
          "deviceTokens": [
            ...subscribers.data.channels[0].credentials.deviceTokens.filter(
              (token: string) => token !== payload.previousToken,
            ),
          ],
        },
        providerId: PushProviderIdEnum.FCM,
      },
    ],
  });
}

async function updateSubscriberProfile(
  subscribers: any,
  payload: Profile,
) {
  if (payload.previousToken === null) {
    throw new Error("Previous token is required for update operation");
  }
  await novu.subscribers.update(payload.user_id, {
    channels: [
      {
        "credentials": {
          "deviceTokens": [
            ...subscribers.data.channels[0].credentials.deviceTokens.filter(
              (token: string) => token !== payload.previousToken,
            ),
            payload.token,
          ],
        },
        providerId: PushProviderIdEnum.FCM,
      },
    ],
  });
}

async function addToSubscriberProfile(
  subscribers: any,
  payload: Profile,
) {
  const existingDeviceTokens =
    subscribers?.data?.channels?.[0]?.credentials?.deviceTokens ?? [];
  const newDeviceTokens = [...existingDeviceTokens, payload.token];

  if (subscribers?.status === 404) {
    // Subscriber not found, create new one
    await novu.subscribers.identify(payload.user_id, {
      channels: [
        {
          credentials: {
            deviceTokens: newDeviceTokens,
          },
          providerId: PushProviderIdEnum.FCM,
        },
      ],
    });
  } else {
    // Subscriber exists, update channels
    await novu.subscribers.update(payload.user_id, {
      channels: [
        {
          credentials: {
            deviceTokens: newDeviceTokens,
          },
          providerId: PushProviderIdEnum.FCM,
        },
      ],
    });
  }
}
/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/manageProfiles' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
