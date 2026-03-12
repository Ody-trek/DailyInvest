import Foundation

struct InvestInsight: Codable, Identifiable {
    let id: UUID
    let date: String        // "yyyy-MM-dd"
    // English content
    let title: String
    let summary: String
    // Chinese content
    let chineseTitle: String
    let chineseSummary: String
    // Source
    let originalTitle: String
    let sourceURL: String
    let sourceName: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        date: String,
        title: String,
        summary: String,
        chineseTitle: String,
        chineseSummary: String,
        originalTitle: String,
        sourceURL: String,
        sourceName: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.summary = summary
        self.chineseTitle = chineseTitle
        self.chineseSummary = chineseSummary
        self.originalTitle = originalTitle
        self.sourceURL = sourceURL
        self.sourceName = sourceName
        self.createdAt = createdAt
    }
}
