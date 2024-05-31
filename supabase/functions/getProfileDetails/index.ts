// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
/// <reference types="https://esm.sh/v135/@supabase/functions-js@2.4.1/src/edge-runtime.d.ts" />
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

console.log("Hello from Functions!");

Deno.serve(async (req) => {
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

  // Get user id from the request
  const { reqUserId } = await req.json();

  // Count number of entries with the user's ID in the 'buddies' table, either as 'requestId' or 'targetId'
  const { data: buddiesData, error: buddiesError } = await supabaseClient
    .from("buddies")
    .select("*")
    .eq("requestId", reqUserId);

  if (buddiesError) {
    throw buddiesError;
  }

  const { data: buddiesData2, error: buddiesError2 } = await supabaseClient
    .from("buddies")
    .select("*")
    .eq("targetId", reqUserId);

  if (buddiesError2) {
    throw buddiesError2;
  }

  const buddiesCount = buddiesData!.length + buddiesData2!.length;

  // Count number of posts with the user's ID in the 'posts' table
  const { data: postsData, error: postsError } = await supabaseClient
    .from("posts")
    .select("*")
    .eq("createdBy", reqUserId);

  // Count how many have images, how many only have text (is postImageURL null?)

  if (postsError) {
    throw postsError;
  }

  const imageCount = postsData!.filter((post) => post.postImageURL).length;
  const textCount = postsData!.length - imageCount;

  // Respond with the created token
  return new Response(
    JSON.stringify({
      "buddies": buddiesCount,
      "pics": imageCount,
      "posts": textCount,
    }),
    {
      status: 200,
      headers: {
        "Content-Type": "application/json",
      },
    },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/getProfileDetails' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
