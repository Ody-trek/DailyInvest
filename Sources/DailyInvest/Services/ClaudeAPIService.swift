import Foundation

enum ClaudeAPIError: LocalizedError {
    case missingAPIKey
    case networkError(Error)
    case decodingError
    case apiError(String)
    case noInsightGenerated

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:    return "Claude API key is not set. Please add it in Settings."
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .decodingError:    return "Failed to decode Claude's response."
        case .apiError(let msg): return "Claude API error: \(msg)"
        case .noInsightGenerated: return "Claude could not generate an insight."
        }
    }
}

// Minimal Codable types for the Claude Messages API
private struct ClaudeRequest: Codable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeMessage]
}

private struct ClaudeMessage: Codable {
    let role: String
    let content: String
}

private struct ClaudeResponse: Codable {
    let content: [ClaudeContentBlock]
}

private struct ClaudeContentBlock: Codable {
    let type: String
    let text: String?
}

struct CuratedInsight {
    let title: String
    let summary: String
    let chineseTitle: String
    let chineseSummary: String
    let originalTitle: String
    let sourceURL: String
    let sourceName: String
}

class ClaudeAPIService {
    private let apiURL = "https://api.anthropic.com/v1/messages"

    func curateInsight(from articles: [NewsArticle], apiKey: String) async throws -> CuratedInsight {
        guard !apiKey.isEmpty else { throw ClaudeAPIError.missingAPIKey }

        let articleList = articles.prefix(15).enumerated().map { index, article in
            """
            [\(index + 1)] Title: \(article.title)
                Source: \(article.source.name)
                Description: \(article.safeDescription)
                URL: \(article.url)
            """
        }.joined(separator: "\n\n")

        let prompt = """
        You are a senior investment analyst. Below is today's list of financial news articles:

        \(articleList)

        Select the single most valuable article for investors and respond ONLY with a JSON object in this exact format (no other text):

        {
          "title": "(A concise English headline, max 10 words)",
          "summary": "(100–150 word English investment insight: why this matters to investors and what the implications are)",
          "chineseTitle": "（中文标题，20字以内）",
          "chineseSummary": "（中文投资洞察，100-150字，解释为何对投资者重要及潜在启示）",
          "originalTitle": "(exact original article title)",
          "sourceURL": "(exact article URL)",
          "sourceName": "(exact source name)"
        }
        """

        let requestBody = ClaudeRequest(
            model: "claude-opus-4-6",
            max_tokens: 1024,
            messages: [ClaudeMessage(role: "user", content: prompt)]
        )

        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ClaudeAPIError.apiError("HTTP \(httpResponse.statusCode): \(errorBody)")
        }

        guard let claudeResponse = try? JSONDecoder().decode(ClaudeResponse.self, from: data),
              let textBlock = claudeResponse.content.first(where: { $0.type == "text" }),
              let text = textBlock.text else {
            throw ClaudeAPIError.decodingError
        }

        return try parseInsightJSON(from: text)
    }

    private func parseInsightJSON(from text: String) throws -> CuratedInsight {
        var jsonString = text
        if let start = text.range(of: "{"), let end = text.range(of: "}", options: .backwards) {
            jsonString = String(text[start.lowerBound...end.upperBound])
        }

        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
              let title = json["title"],
              let summary = json["summary"],
              let chineseTitle = json["chineseTitle"],
              let chineseSummary = json["chineseSummary"],
              let originalTitle = json["originalTitle"],
              let sourceURL = json["sourceURL"],
              let sourceName = json["sourceName"] else {
            throw ClaudeAPIError.noInsightGenerated
        }

        return CuratedInsight(
            title: title,
            summary: summary,
            chineseTitle: chineseTitle,
            chineseSummary: chineseSummary,
            originalTitle: originalTitle,
            sourceURL: sourceURL,
            sourceName: sourceName
        )
    }
}
