import Foundation

enum NewsAPIError: LocalizedError {
    case invalidURL
    case missingAPIKey
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:       return "Invalid URL"
        case .missingAPIKey:    return "NewsAPI key is not set. Please add it in Settings."
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        case .apiError(let msg): return "API error: \(msg)"
        }
    }
}

class NewsAPIService {
    private let baseURL = "https://newsapi.org/v2/everything"

    func fetchInvestmentNews(apiKey: String) async throws -> [NewsArticle] {
        guard !apiKey.isEmpty else { throw NewsAPIError.missingAPIKey }

        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: "investment OR stock market OR Warren Buffett OR finance"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "apiKey", value: apiKey),
        ]

        guard let url = components.url else { throw NewsAPIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NewsAPIError.apiError("HTTP \(httpResponse.statusCode)")
        }

        do {
            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            if newsResponse.status != "ok" {
                throw NewsAPIError.apiError(newsResponse.status)
            }
            return newsResponse.articles.filter { !$0.title.contains("[Removed]") }
        } catch let error as NewsAPIError {
            throw error
        } catch {
            throw NewsAPIError.decodingError(error)
        }
    }
}
