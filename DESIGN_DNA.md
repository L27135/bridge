# Bridge Design DNA

Reference: Calm and Headspace visual language, interpreted through the product thesis and core intervention research.

## Product posture

Bridge is not an AI therapist. It is a quiet care-continuity layer.

The consumer experience should help the user feel:

- calmer, not monitored
- oriented, not classified
- in control, not evaluated
- close to human support, not dependent on the AI

The provider experience should feel:

- calm and concise
- source-labeled
- useful without pretending to be a medical record
- explicit about what the patient approved

## Design principles

1. Chat is the main consumer interaction.
   The user should feel like they are messaging a calm support assistant, not filling out a clinical triage form.

2. Safety modes stay hidden.
   Internal risk/mode logic should affect routing and recommendations, but should not be displayed as yellow/orange/red labels to the consumer unless there is an immediate safety instruction.

3. Profile building is quiet and reviewable.
   The app may organize a draft profile while the user talks, but durable memory requires user review.

4. Consent is the product moment.
   The user should clearly see what is included, what is excluded, who can see it, and when access expires.

5. Provider UI gets signal, not noise.
   No raw transcript by default. Show Bridge Card, source labels, visibility scope, timeline, and patient-approved context.

## Visual Language

- Headspace + Calm visual language: warm, spacious, rounded, and gentle.
- Palette: soft sage greens, lavender, warm whites, cream, pale peach, and gentle neutrals.
- No harsh black and no corporate blue. Use warm ink and deep sage for WCAG AA contrast.
- Headlines should feel human: friendly serif or rounded/friendly sans-serif, generous line height, never dense.
- Body text should be light in feeling but still readable; use ample line height and avoid clinical density.
- Large radius on all cards, buttons, chips, panels, and inputs.
- Soft shadows only. Avoid hard borders; if a separator is needed, make it warm and low contrast.
- No clinical warning colors on consumer screens.
- No chatbot mascot, therapist avatar, streaks, gamification, or urgent mode badges.
- Motion should feel like an exhale: slow fades, subtle scale on hover, smooth transitions, nothing abrupt.
- Illustrations and icons should be soft, minimal, and nature-adjacent.
- WCAG AA contrast is required despite the soft palette.

## Components

Consumer app:

- Chat thread
- Suggested reply chips
- Quiet profile preview
- Review profile draft
- Bridge Card draft
- Consent scope checklist
- Share preview
- Session recommendation card

Provider app:

- Patient-approved packet header
- Bridge Card summary
- Vault visibility matrix
- Source labels
- Consent scope
- Recent timeline
- Recommended session focus

## Copy rules

Use:

- "I can help you organize this."
- "You choose what gets saved."
- "You choose what gets shared."
- "Would setting up a session help?"
- "Here is a short summary you can review."
- "How are you feeling?"
- "Let’s keep this gentle."

Avoid:

- "Risk level"
- "Urgent mode"
- "Yellow / orange / red"
- "Diagnosis"
- "Treatment plan"
- "AI therapist"
- "Select mood status"
- "Patient data submitted"
- "I will always be here"
- "I understand you better than anyone"

## UI prompt to pass into UI work

Build in Bridge's Headspace-and-Calm-inspired design DNA: chat-first, emotionally safe, warm muted palette of sage, lavender, warm whites, cream, peach, and gentle neutrals. Use no harsh blacks and no corporate blues. Use rounded corners everywhere, generous whitespace, soft card shadows, friendly human typography, gentle motion, and warm conversational copy. Consumer screens should feel like an exhale: no visible risk/mode labels, no clinical density, no urgency unless immediate human support is needed. Preserve the thesis that AI structures, prepares, routes, and preserves context; it does not diagnose, treat, or replace human care. Provider surfaces should remain warm, source-labeled, patient-approved, compact enough to be useful, and focused on actionable context.
