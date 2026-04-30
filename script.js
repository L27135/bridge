const views = {
  chat: "Chat with Bridge",
  profile: "Review your care context",
  consent: "Choose what to share",
};

const navItems = document.querySelectorAll(".nav-link[data-view]");
const viewPanels = document.querySelectorAll(".view");
const messages = document.querySelector("#messages");
const composer = document.querySelector("#composer");
const chatInput = document.querySelector("#chat-input");
const quietContext = document.querySelector(".quiet-context");
const includedList = document.querySelector("#included-list");
const excludedList = document.querySelector("#excluded-list");

const profile = {
  concern: "Trouble sleeping after a relationship stressor",
  trigger: "Delayed replies and repeated phone checking",
  pattern: "Sleep loss + phone checking",
  nextStep: "Prepare for a therapist",
  card:
    "Alex could not sleep and was stuck checking their phone after feeling rejected.",
};

let userMessageCount = 0;
let gearShiftShown = false;
const conversationMessages = [
  {
    role: "assistant",
    content:
      "I’m here to help you sort through the moment gently. You can vent, slow things down, or get ready to talk with someone.",
  },
];

function setView(id) {
  navItems.forEach((item) => item.classList.toggle("active", item.dataset.view === id));
  viewPanels.forEach((panel) => panel.classList.toggle("active", panel.id === id));
}

function addMessage(role, text) {
  const article = document.createElement("article");
  article.className = `message ${role}`;
  const paragraph = document.createElement("p");
  paragraph.textContent = text;
  article.append(paragraph);
  messages.append(article);
  messages.scrollTop = messages.scrollHeight;
  return article;
}

function rememberMessage(role, content) {
  conversationMessages.push({ role, content });
}

function addThinkingMessage() {
  const article = document.createElement("article");
  article.className = "message assistant thinking";
  article.setAttribute("aria-label", "Bridge is writing");
  article.innerHTML = "<span></span><span></span><span></span>";
  messages.append(article);
  messages.scrollTop = messages.scrollHeight;
  return article;
}

function addGearShiftCard() {
  if (gearShiftShown) return;
  gearShiftShown = true;

  const article = document.createElement("article");
  article.className = "gear-shift-card";
  article.innerHTML = `
    <p>It sounds like this has been weighing on you. Want help getting ready to talk to your therapist?</p>
    <div class="gear-shift-actions">
      <button type="button" data-gear-action="prep">Yes, help me prep</button>
      <button type="button" data-gear-action="later">Not now</button>
      <button type="button" data-gear-action="talk">Just keep talking</button>
    </div>
  `;
  messages.append(article);
  messages.scrollTop = messages.scrollHeight;
}

function handleGearShiftAction(action) {
  if (action === "prep") {
    const reply =
      "Absolutely. We can make this easier to bring into session. What is the main thing you want your therapist to understand first?";
    addMessage("assistant", reply);
    rememberMessage("assistant", reply);
    profile.nextStep = "Therapy prep started";
    renderProfile();
    quietContext?.classList.remove("is-hidden");
    return;
  }

  if (action === "later") {
    const reply =
      "Of course. We can leave it there for now. You can come back to prep whenever it feels useful.";
    addMessage("assistant", reply);
    rememberMessage("assistant", reply);
    return;
  }

  const reply =
    "That is okay. We can keep talking gently, and I will help you keep it organized as we go.";
  addMessage("assistant", reply);
  rememberMessage("assistant", reply);
}

function resizeComposer() {
  if (!chatInput) return;
  chatInput.style.height = "auto";
  chatInput.style.height = `${Math.min(chatInput.scrollHeight, 160)}px`;
}

function inferProfile(text) {
  const lower = text.toLowerCase();

  if (lower.includes("sleep") || lower.includes("tired")) {
    profile.concern = "Sleep disruption connected to emotional stress";
    profile.pattern = "Sleep disruption + rumination";
  }

  if (lower.includes("phone") || lower.includes("text") || lower.includes("reply")) {
    profile.trigger = "Phone checking after delayed replies";
  }

  if (lower.includes("session") || lower.includes("therapist")) {
    profile.nextStep = "Prepare for a therapist";
  } else if (lower.includes("someone") || lower.includes("friend") || lower.includes("talk")) {
    profile.nextStep = "Reach out to a trusted person";
  }

  profile.card = `Alex described ${profile.concern.toLowerCase()} with a pattern of ${profile.trigger.toLowerCase()}.`;
  renderProfile();
}

async function bridgeReply(messagesForRequest) {
  const response = await fetch("/api/chat", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      messages: messagesForRequest,
    }),
  });

  if (!response.ok) {
    throw new Error(`Chat request failed: ${response.status}`);
  }

  const data = await response.json();
  return (
    data.reply?.trim() ||
    "I’m here with you. Let’s keep this small and choose one gentle next step."
  );
}

function safetyReply(text) {
  const lower = text.toLowerCase();

  if (lower.includes("hurt myself") || lower.includes("kill myself") || lower.includes("danger")) {
    return "I am really glad you said that. This is a moment for immediate human support. If you might act on those thoughts or are in danger, call emergency services now. If you can, contact a trusted person and stay near someone while you get help.";
  }

  if (lower.includes("session") || lower.includes("therapist")) {
    return "That sounds like the right kind of next step. I can help make a short Bridge Card for the session, and you can choose exactly how much of this conversation to share.";
  }
  return null;
}

function renderProfile() {
  const patternPreview = document.querySelector("#pattern-preview");
  const nextStepPreview = document.querySelector("#next-step-preview");
  const profileConcern = document.querySelector("#profile-concern");
  const profileTrigger = document.querySelector("#profile-trigger");
  const cardSummary = document.querySelector("#card-summary");

  if (patternPreview) patternPreview.textContent = profile.pattern;
  if (nextStepPreview) nextStepPreview.textContent = profile.nextStep;
  if (profileConcern) profileConcern.textContent = profile.concern;
  if (profileTrigger) profileTrigger.textContent = profile.trigger;
  if (cardSummary) cardSummary.textContent = profile.card;
}

function updateScopeLists() {
  const scopes = [...document.querySelectorAll("[data-scope]")];
  const included = scopes.filter((item) => item.checked).map((item) => item.dataset.scope);
  const excluded = scopes.filter((item) => !item.checked).map((item) => item.dataset.scope);

  if (includedList) includedList.innerHTML = included.map((item) => `<li>${item}</li>`).join("");
  if (excludedList) excludedList.innerHTML = excluded.map((item) => `<li>${item}</li>`).join("");

  const accessLevel = document.querySelector("#access-level");
  if (accessLevel) {
    accessLevel.textContent =
      included.length <= 4 && !included.includes("Raw chat transcript") ? "Summary only" : "Expanded";
  }
}

navItems.forEach((item) => {
  item.addEventListener("click", () => setView(item.dataset.view));
});

document.querySelectorAll("[data-go]").forEach((button) => {
  button.addEventListener("click", () => setView(button.dataset.go));
});

document.querySelectorAll("[data-template]").forEach((button) => {
  button.addEventListener("click", () => {
    chatInput.value = button.dataset.template;
    resizeComposer();
    chatInput.focus();
  });
});

if (composer) {
  composer.addEventListener("submit", (event) => {
    event.preventDefault();
    const text = chatInput.value.trim();
    if (!text) return;

    userMessageCount += 1;
    addMessage("user", text);
    rememberMessage("user", text);
    inferProfile(text);
    quietContext?.classList.remove("is-hidden");
    chatInput.value = "";
    resizeComposer();

    const crisisResponse = safetyReply(text);
    if (crisisResponse) {
      addMessage("assistant", crisisResponse);
      rememberMessage("assistant", crisisResponse);
      if (userMessageCount >= 3) addGearShiftCard();
      return;
    }

    const thinking = addThinkingMessage();
    const messagesForRequest = [...conversationMessages];
    window.setTimeout(async () => {
      thinking.remove();
      try {
        const reply = await bridgeReply(messagesForRequest);
        addMessage("assistant", reply);
        rememberMessage("assistant", reply);
      } catch (error) {
        console.error(error);
        const fallback =
          "I’m having trouble connecting right now. We can still keep this simple: what is one piece of this you want to organize first?";
        addMessage("assistant", fallback);
        rememberMessage("assistant", fallback);
      }
      if (userMessageCount >= 3) addGearShiftCard();
    }, 650);
  });
}

if (messages) {
  messages.addEventListener("click", (event) => {
    const button = event.target.closest("[data-gear-action]");
    if (!button) return;
    const card = button.closest(".gear-shift-card");
    if (card) card.remove();
    handleGearShiftAction(button.dataset.gearAction);
  });
}

if (chatInput) {
  chatInput.addEventListener("input", resizeComposer);
  chatInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      composer?.requestSubmit();
    }
  });
}

document.querySelectorAll("[data-scope]").forEach((item) => {
  item.addEventListener("change", updateScopeLists);
});

renderProfile();
updateScopeLists();
