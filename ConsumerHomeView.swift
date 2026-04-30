import SwiftUI

struct ConsumerHomeView: View {
    @State private var draftMessage = ""
    @State private var messages: [BridgeMessage] = [
        BridgeMessage(role: .assistant, text: "I can help you sort this out gently. We can keep it small: calm down, explain what happened, or prepare something to share."),
        BridgeMessage(role: .user, text: "I can't sleep. I keep checking my phone and I feel like everyone hates me."),
        BridgeMessage(role: .assistant, text: "That sounds painful and tiring. I can help you slow the loop down and make a short summary for a therapist or trusted person, if you choose.")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                BridgeBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        header
                        chatSurface
                        profileDraft
                    }
                    .padding()
                }
            }
            .navigationTitle("Bridge")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PRIVATE SUPPORT")
                .font(.caption.weight(.bold))
                .foregroundStyle(BridgePalette.cream)

            Text("What would help right now?")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)

            Text("Bridge helps you organize what is happening and prepare for the right human support.")
                .foregroundStyle(.white.opacity(0.86))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var chatSurface: some View {
        SoftSurface {
            VStack(spacing: 14) {
                ForEach(messages) { message in
                    MessageBubble(message: message)
                }

                HStack {
                    TextField("Message Bridge...", text: $draftMessage, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.headline.weight(.bold))
                            .frame(width: 42, height: 42)
                            .background(BridgePalette.deepSage, in: Circle())
                            .foregroundStyle(.white)
                    }
                    .accessibilityLabel("Send")
                }
            }
        }
    }

    private var profileDraft: some View {
        SoftSurface {
            VStack(alignment: .leading, spacing: 14) {
                Text("QUIETLY ORGANIZING")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BridgePalette.deepSage)

                Text("Your draft profile")
                    .font(.title2.weight(.bold))

                Text("Nothing is saved permanently or shared until you review it.")
                    .foregroundStyle(BridgePalette.muted)

                ProfileSignal(title: "Pattern", value: "Sleep loss + phone checking")
                ProfileSignal(title: "Helpful next step", value: "Prepare for a therapist")
                ProfileSignal(title: "Visibility", value: "Private draft")
            }
        }
    }

    private func send() {
        let text = draftMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(BridgeMessage(role: .user, text: text))
        messages.append(BridgeMessage(role: .assistant, text: reply(for: text)))
        draftMessage = ""
    }

    private func reply(for text: String) -> String {
        let lower = text.lowercased()
        if lower.contains("session") || lower.contains("therapist") {
            return "That sounds like the right kind of next step. I can help make a short Bridge Card, and you choose exactly how much to share."
        }
        return "Let us keep this small. We can name the pattern and choose one next human-supported step."
    }
}

struct BridgeMessage: Identifiable {
    let id = UUID()
    let role: BridgeRole
    let text: String
}

enum BridgeRole {
    case assistant
    case user
}

struct MessageBubble: View {
    let message: BridgeMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 36) }
            Text(message.text)
                .padding(14)
                .background(background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(message.role == .user ? .white : BridgePalette.ink)
            if message.role == .assistant { Spacer(minLength: 36) }
        }
    }

    private var background: Color {
        message.role == .user ? BridgePalette.deepSage : .white.opacity(0.72)
    }
}

struct ProfileSignal: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(BridgePalette.muted)
            Text(value)
                .font(.body.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
