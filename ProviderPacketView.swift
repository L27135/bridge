import SwiftUI

struct ProviderPacketView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ProviderHeader()
                    BridgeCardSection()
                    VaultVisibilitySection()
                    TimelineSection()
                }
                .padding()
            }
            .background(BridgePalette.cream)
            .navigationTitle("Provider Packet")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProviderHeader: View {
    var body: some View {
        SoftSurface {
            VStack(alignment: .leading, spacing: 8) {
                Text("PATIENT-APPROVED PACKET")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BridgePalette.deepSage)
                Text("Alex Morgan")
                    .font(.largeTitle.weight(.bold))
                Text("Access expires May 30, 2026")
                    .foregroundStyle(BridgePalette.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct BridgeCardSection: View {
    var body: some View {
        SoftSurface {
            VStack(alignment: .leading, spacing: 14) {
                Text("BRIDGE CARD")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BridgePalette.deepSage)
                Text("What Alex wants help with")
                    .font(.title2.weight(.bold))
                Text("Alex had a difficult night with sleep disruption and repeated phone checking after feeling rejected. They want help discussing the pattern without having to retell everything from scratch.")
                    .foregroundStyle(BridgePalette.muted)
                HStack {
                    SourceLabel(text: "User said", color: BridgePalette.deepSage)
                    SourceLabel(text: "AI summarized", color: BridgePalette.lavenderDeep)
                    SourceLabel(text: "Raw chat hidden", color: BridgePalette.muted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct VaultVisibilitySection: View {
    private let rows = [
        ("Bridge Card summary", "Visible"),
        ("Current concern", "Visible"),
        ("Known triggers", "Visible"),
        ("What helped before", "Visible"),
        ("Medication history", "Hidden"),
        ("Sensitive history", "Hidden"),
        ("Raw chat transcript", "Hidden")
    ]

    var body: some View {
        SoftSurface {
            VStack(alignment: .leading, spacing: 12) {
                Text("VAULT VISIBILITY")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BridgePalette.deepSage)
                Text("What this provider can see")
                    .font(.title2.weight(.bold))

                ForEach(rows, id: \.0) { row in
                    HStack {
                        Text(row.0)
                        Spacer()
                        Text(row.1)
                            .fontWeight(.bold)
                            .foregroundStyle(row.1 == "Visible" ? BridgePalette.deepSage : BridgePalette.privateText)
                    }
                    .padding(12)
                    .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}

struct TimelineSection: View {
    var body: some View {
        SoftSurface {
            VStack(alignment: .leading, spacing: 12) {
                Text("RECENT TIMELINE")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(BridgePalette.deepSage)
                Text("Context without transcript overload")
                    .font(.title2.weight(.bold))
                Text("Late evening: trouble sleeping and repeated phone checking.")
                Text("During chat: user asked to organize the situation and prepare for a session.")
                Text("After review: user approved a short Bridge Card and kept raw chat private.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(BridgePalette.muted)
        }
    }
}

private extension BridgePalette {
    static let privateText = Color(red: 0.45, green: 0.40, blue: 0.34)
}
