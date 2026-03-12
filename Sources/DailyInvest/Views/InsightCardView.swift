import SwiftUI

struct InsightCardView: View {
    let insight: InvestInsight
    @State private var showChinese = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Language toggle
            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showChinese.toggle()
                    }
                } label: {
                    Label(
                        showChinese ? "English" : "中文",
                        systemImage: showChinese ? "textformat.abc" : "character.chinese"
                    )
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(20)
                }
                .buttonStyle(.plain)
            }

            // Title
            Text(showChinese ? insight.chineseTitle : insight.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineSpacing(4)
                .animation(.easeInOut, value: showChinese)

            Divider()

            // Summary
            Text(showChinese ? insight.chineseSummary : insight.summary)
                .font(.body)
                .lineSpacing(6)
                .foregroundColor(.primary)
                .animation(.easeInOut, value: showChinese)

            Divider()

            // Source info
            VStack(alignment: .leading, spacing: 6) {
                Label(insight.sourceName, systemImage: "newspaper")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Original: \(insight.originalTitle)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            // Read original button
            if let url = URL(string: insight.sourceURL) {
                Link(destination: url) {
                    Label("Read Original Article", systemImage: "arrow.up.right.square")
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

// Compact card for history list
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
                .lineLimit(2)
            Text(insight.chineseTitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
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
