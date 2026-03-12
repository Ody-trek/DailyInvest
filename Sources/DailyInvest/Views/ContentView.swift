import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = InsightViewModel()

    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Label("Today", systemImage: "star.fill")
                }

            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
