import SwiftUI

struct InsightCardView: View {
    let insight: InvestInsight

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(insight.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineSpacing(4)

            Divider()

            Text(insight.summary)
                .font(.body)
                .lineSpacing(6)
                .foregroundColor(.primary)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label(insight.sourceName, systemImage: "newspaper")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("原标题：\(insight.originalTitle)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            if let url = URL(string: insight.sourceURL) {
                Link(destination: url) {
                    Label("阅读原文", systemImage: "arrow.up.right.square")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct InsightRowView: View {
    let insight: InvestInsight

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(formattedDate(insight.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(insight.sourceName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(insight.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            Text(insight.summary)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }

    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M月d日"
        outputFormatter.locale = Locale(identifier: "zh_CN")
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        return outputFormatter.string(from: date)
    }
}
