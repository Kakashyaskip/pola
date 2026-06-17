import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .films
    @State private var showCreateEvent = false

    enum Tab { case films, settings }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .films:
                    FilmsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab bar custom
            HStack(spacing: 0) {
                TabBarItem(
                    icon: "film",
                    label: "Films",
                    isSelected: selectedTab == .films
                ) {
                    selectedTab = .films
                }

                // Bouton central créer
                Button {
                    showCreateEvent = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.polaOrange)
                            .frame(width: 52, height: 52)
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .offset(y: -8)

                TabBarItem(
                    icon: "gearshape",
                    label: "Réglages",
                    isSelected: selectedTab == .settings
                ) {
                    selectedTab = .settings
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .frame(height: 72)
            .background(
                Color.polaBlack
                    .opacity(0.95)
                    .ignoresSafeArea(edges: .bottom)
            )
            .overlay(alignment: .top) {
                Divider().opacity(0.1)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showCreateEvent) {
            CreateEventView()
        }
    }
}

private struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? icon + ".fill" : icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.polaCaption(10))
            }
            .foregroundStyle(isSelected ? Color.white : Color(white: 0.45))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
        .environment(AuthViewModel())
}
