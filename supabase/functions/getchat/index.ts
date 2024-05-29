import { StreamChat } from "npm:stream-chat";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

const corsHeaders = {
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const serverClient = StreamChat.getInstance(
  Deno.env.get("STREAM_API_KEY")!,
  Deno.env.get("STREAM_API_SECRET"),
);

Deno.serve(async (req: Request) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Create a Supabase client with the Auth context of the logged in user.
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      },
    );

    const { data } = await supabaseClient.auth.getUser();
    const userId = data!.user!.id;

    // Valid user ID check
    if (!userId) {
      throw new Error("User not found");
    }

    // Create a token using the userId
    try {
      const token = serverClient.createToken(userId);
      console.log("token:", token);

      // Respond with the created token
      return new Response(JSON.stringify({ token: token }), {
        status: 200,
        headers: {
          "Content-Type": "application/json",
        },
      });
    } catch (error) {
      return new Response(JSON.stringify({ error1: error.message }), {
        status: 500,
        headers: {
          "Content-Type": "application/json",
        },
      });
    }
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
