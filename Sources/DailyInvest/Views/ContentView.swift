import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = InsightViewModel()

    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Label("今日", systemImage: "star.fill")
                }

            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("历史", systemImage: "clock.fill")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
        }
    }
}
