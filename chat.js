const BRIDGE_SYSTEM_PROMPT =
  "You are Bridge, a warm, calm support assistant. You are NOT a therapist. Your job is to help the user organize their thoughts and gently guide them toward human support when appropriate. Keep replies short, warm, and conversational. Never validate distorted beliefs. Never act like a best friend.";

function sendJson(res, status, body) {
  res.statusCode = status;
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify(body));
}

function sanitizeMessages(messages) {
  if (!Array.isArray(messages)) return null;

  return messages
    .filter((message) => message && ["user", "assistant"].includes(message.role))
    .map((message) => ({
      role: message.role,
      content: String(message.content || "").slice(0, 4000),
    }))
    .filter((message) => message.content.trim().length > 0)
    .slice(-12);
}

module.exports = async function handler(req, res) {
  if (req.method !== "POST") {
    return sendJson(res, 405, { error: "Method not allowed" });
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return sendJson(res, 500, { error: "OPENAI_API_KEY is not configured" });
  }

  const messages = sanitizeMessages(req.body?.messages);
  if (!messages || messages.length === 0) {
    return sendJson(res, 400, { error: "Request body must include messages" });
  }

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        messages: [{ role: "system", content: BRIDGE_SYSTEM_PROMPT }, ...messages],
        temperature: 0.7,
        max_tokens: 140,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      return sendJson(res, response.status, {
        error: "OpenAI request failed",
        detail: errorText.slice(0, 500),
      });
    }

    const data = await response.json();
    const reply =
      data.choices?.[0]?.message?.content?.trim() ||
      "I’m here with you. Let’s keep this small and choose one gentle next step.";

    return sendJson(res, 200, { reply });
  } catch (error) {
    return sendJson(res, 500, {
      error: "Chat request failed",
      detail: error instanceof Error ? error.message : "Unknown error",
    });
  }
};
