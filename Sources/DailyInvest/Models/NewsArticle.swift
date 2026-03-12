import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String
    let description: String?
    let url: String
    let source: NewsSource
    let publishedAt: String

    var safeDescription: String {
        description ?? "No description available."
    }
}

struct NewsSource: Codable {
    let name: String
}
