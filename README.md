# Bridge

A consumer and provider prototype for a mental-health care continuity product.

Bridge is intentionally not framed as AI therapy. It demonstrates a safer loop:

1. Help a distressed user organize the moment through a normal chat interface.
2. Quietly draft profile context while keeping it private.
3. Let the user review what Bridge understood.
4. Ask for explicit consent before sharing anything.
5. Give the provider a concise patient-approved packet instead of raw chat.

## Design DNA

All UI work should use [DESIGN_DNA.md](DESIGN_DNA.md) as the product and visual brief.

## Web Apps

- Consumer app: `index.html`
- Provider app: `provider.html`
- Shared styling: `styles.css`
- Shared consumer behavior: `script.js`

Run locally:

```bash
python3 -m http.server 4173
```

Then open `http://localhost:4173`.

The OpenAI call is handled by the Vercel serverless function in `api/chat.js`.
Set `OPENAI_API_KEY` in Vercel before deploying. For local testing of the API
route, use Vercel's local dev server instead of the plain Python static server.

## iOS Prototype

SwiftUI source sketches live in `ios/BridgePrototype/`. They mirror the consumer/provider split and use the same design DNA.
