import Foundation

enum ClaudeAPIError: LocalizedError {
    case missingAPIKey
    case networkError(Error)
    case decodingError
    case apiError(String)
    case noInsightGenerated

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:    return "未配置 Claude API Key，请在设置页面填写。"
        case .networkError(let e): return "网络错误：\(e.localizedDescription)"
        case .decodingError:    return "解析 Claude 返回内容失败。"
        case .apiError(let msg): return "Claude API 错误：\(msg)"
        case .noInsightGenerated: return "Claude 未能生成洞察内容。"
        }
    }
}

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
            [\(index + 1)] 标题：\(article.title)
                来源：\(article.source.name)
                摘要：\(article.safeDescription)
                链接：\(article.url)
            """
        }.joined(separator: "\n\n")

        let prompt = """
        你是一位资深投资分析师。以下是今天的财经新闻列表：

        \(articleList)

        请从中选出**最有投资价值**的一条，并按照以下 JSON 格式回复（只输出 JSON，不要任何其他文字）：

        {
          "title": "（用中文写一个吸引人的标题，20字以内）",
          "summary": "（用中文写100-150字的投资洞察，解释为什么这条信息对投资者重要，以及潜在的投资启示）",
          "originalTitle": "（原文标题，原样复制）",
          "sourceURL": "（原文链接，原样复制）",
          "sourceName": "（来源媒体名称，原样复制）"
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
            let errorBody = String(data: data, encoding: .utf8) ?? "未知错误"
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
              let originalTitle = json["originalTitle"],
              let sourceURL = json["sourceURL"],
              let sourceName = json["sourceName"] else {
            throw ClaudeAPIError.noInsightGenerated
        }

        return CuratedInsight(
            title: title,
            summary: summary,
            originalTitle: originalTitle,
            sourceURL: sourceURL,
            sourceName: sourceName
        )
    }
}
