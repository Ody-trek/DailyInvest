import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: InsightViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.allInsights.isEmpty {
                    emptyView
                } else {
                    list
                }
            }
            .navigationTitle("History")
        }
        .onAppear {
            viewModel.loadFromStorage()
        }
    }

    private var list: some View {
        List(viewModel.allInsights) { insight in
            NavigationLink(destination: InsightDetailView(insight: insight)) {
                InsightRowView(insight: insight)
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No history yet")
                .font(.headline)
            Text("Each day's insight will be saved here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InsightDetailView: View {
    let insight: InvestInsight

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                InsightCardView(insight: insight)
            }
            .padding()
        }
        .navigationTitle(formattedDate(insight.date))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        return outputFormatter.string(from: date)
    }
}
