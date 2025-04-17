import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js";

type SupabasePayload = {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  schema: "public";
  old_record: PublicUserProfileRecord | null;
  record: PublicUserProfileRecord | null;
};

interface PublicUserProfileRecord {
  user_id: string;
  username: string;
}

Deno.serve(async (req) => {
  const payload = await req.json() as SupabasePayload;
  const apiMethod = payload.type === "INSERT" ? "POST" : "PATCH";

  // Prepare the API endpoint and method based on the request type, add userId if method is patch
  let apiUrl = `https://api.resend.com/audiences/${
    Deno.env.get("RESEND_AUDIENCE_ID")
  }/contacts`;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  if (payload.type === "INSERT" || payload.type === "UPDATE") {
    const { user_id, username } = payload.record ?? {};

    if (!user_id) {
      return new Response(
        JSON.stringify({
          error: "Missing user_id",
        }),
      );
    }

    // Fetch the user's email
    const { data: user, error: userError } = await supabase.auth.admin
      .getUserById(user_id!);

    if (userError) {
      return new Response(
        JSON.stringify({
          error: "Failed to fetch user",
        }),
      );
    }

    // If patch, add the user_id to the API URL
    if (payload.type === "UPDATE") {
      apiUrl += `/${user.user?.email}`;
    }

    // Create or update the contact using Resend API
    const response = await fetch(apiUrl, {
      method: apiMethod,
      headers: {
        "Authorization": `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: user.user?.email,
        firstName: username,
        audienceId: Deno.env.get("RESEND_AUDIENCE_ID"),
      }),
    });
    console.log(await response.json());
    if (!response.ok) {
      return new Response(
        JSON.stringify({
          error: "Failed to create or update contact",
        }),
        {
          status: 500,
        },
      );
    }

    // Update the user's metadata with the Resend contact ID
    await supabase.auth.admin.updateUserById(
      user_id!,
      {
        user_metadata: {
          ...user.user?.user_metadata,
          resend_contact_id: user.user?.id,
        },
      },
    );

    return new Response(
      JSON.stringify({
        message: "Contact created or updated successfully",
      }),
      {
        status: 200,
      },
    );
  } else if (payload.type === "DELETE") {
    // Fetch the user's email
    const { data: user, error: userError } = await supabase.auth.admin
      .getUserById(payload.old_record?.user_id!);

    if (userError) {
      return new Response(
        JSON.stringify({
          error: "Failed to fetch user",
        }),
      );
    }
    apiUrl += `/${user.user?.email}`;
    const response = await fetch(apiUrl, {
      method: "DELETE",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
      },
    });
    if (!response.ok) {
      return new Response(
        JSON.stringify({
          error: "Failed to delete contact",
        }),
      );
    }
    return new Response(
      JSON.stringify({
        message: "Contact deleted successfully",
      }),
    );
  }

  return new Response(
    JSON.stringify({
      error: "Method not allowed",
    }),
    {
      status: 405,
    },
  );
});
