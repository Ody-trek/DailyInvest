import Foundation

class InsightStore {
    static let shared = InsightStore()

    private let fileName = "insights.json"

    private var fileURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(fileName)
    }

    func save(_ insights: [InvestInsight]) {
        guard let data = try? JSONEncoder().encode(insights) else { return }
        try? data.write(to: fileURL)
    }

    func load() -> [InvestInsight] {
        guard let data = try? Data(contentsOf: fileURL),
              let insights = try? JSONDecoder().decode([InvestInsight].self, from: data) else {
            return []
        }
        return insights.sorted { $0.date > $1.date }
    }

    func todayInsight() -> InvestInsight? {
        let today = todayString()
        return load().first { $0.date == today }
    }

    func addInsight(_ insight: InvestInsight) {
        var insights = load()
        // Remove existing insight for the same date if any
        insights.removeAll { $0.date == insight.date }
        insights.append(insight)
        save(insights)
    }

    func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
