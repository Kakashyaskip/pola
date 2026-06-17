import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.polaPaper.ignoresSafeArea()

            Text("pola")
                .font(.polaWordmark())
                .foregroundStyle(Color.polaBlack)
                .kerning(-2)
                .textCase(.lowercase)
        }
    }
}

#Preview {
    ContentView()
}
