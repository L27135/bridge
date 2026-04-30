import SwiftUI

@main
struct BridgePrototypeApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}

struct AppRootView: View {
    @State private var selectedTab: BridgeTab = .consumer

    var body: some View {
        TabView(selection: $selectedTab) {
            ConsumerHomeView()
                .tabItem { Label("Bridge", systemImage: "message.fill") }
                .tag(BridgeTab.consumer)

            ProviderPacketView()
                .tabItem { Label("Provider", systemImage: "doc.text.fill") }
                .tag(BridgeTab.provider)
        }
        .tint(BridgePalette.deepSage)
    }
}

enum BridgeTab {
    case consumer
    case provider
}
