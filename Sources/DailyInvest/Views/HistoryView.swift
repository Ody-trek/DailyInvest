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
            .navigationTitle("历史洞察")
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
            Text("暂无历史记录")
                .font(.headline)
            Text("每天的投资洞察会保存在这里")
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
        outputFormatter.dateFormat = "yyyy年M月d日"
        outputFormatter.locale = Locale(identifier: "zh_CN")
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        return outputFormatter.string(from: date)
    }
}
