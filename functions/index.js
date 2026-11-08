/**
 * Example Firebase Cloud Function / Node.js backend proxy
 * for LinguaGo AI Tutor Service.
 *
 * Keep your LLM API Key (e.g. GEMINI_API_KEY or OPENAI_API_KEY) SECURELY
 * in environment variables on your server or Google Cloud Secret Manager.
 * Never embed the API key inside the client Flutter application.
 */

const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Retrieve API key securely from environment configuration
const apiKey = process.env.GEMINI_API_KEY || functions.config().gemini?.key;
const genAI = apiKey ? new GoogleGenerativeAI(apiKey) : null;

exports.aiTutorProxy = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  if (req.method !== "POST") {
    res.status(405).json({ error: "Method not allowed" });
    return;
  }

  try {
    const { scenario, userText, history } = req.body;

    if (!userText || !scenario) {
      res.status(400).json({ error: "Missing scenario or userText" });
      return;
    }

    if (!genAI) {
      res.status(500).json({
        error: "Backend LLM API key not configured on server.",
      });
      return;
    }

    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      generationConfig: {
        responseMimeType: "application/json",
      },
    });

    const systemPrompt = `
You are an English language tutor in an educational mobile app.
Your role: ${scenario.aiRole}.
The learner's role: ${scenario.userRole}.
Scenario setting: "${scenario.title}" - ${scenario.subtitle}.

RULES:
1. Reply in simple, conversational English (CEFR A2-B1).
2. Stay strictly in character for the scenario.
3. If the user made a grammar, vocabulary, or phrasing mistake, identify at most ONE mistake and provide a gentle correction and short grammar tip.
4. Do NOT overwhelm the learner with multiple corrections.
5. Keep your response short (1 to 3 sentences maximum) to keep the dialogue flowing.
6. Return valid JSON only with keys: "reply", "correction", "grammarTip". If no correction is needed, set "correction" and "grammarTip" to null.
`;

    const chat = model.startChat({
      history: [
        {
          role: "user",
          parts: [{ text: systemPrompt }],
        },
        {
          role: "model",
          parts: [
            {
              text: JSON.stringify({
                reply: scenario.initialAiMessage,
                correction: null,
                grammarTip: null,
              }),
            },
          ],
        },
      ],
    });

    const result = await chat.sendMessage(userText);
    const text = result.response.text();
    const parsed = JSON.parse(text);

    res.status(200).json(parsed);
  } catch (error) {
    console.error("AI Tutor Proxy Error:", error);
    res.status(500).json({ error: "Failed to process tutor response" });
  }
});
