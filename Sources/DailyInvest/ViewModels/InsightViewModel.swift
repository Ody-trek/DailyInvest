import Foundation
import SwiftUI

@MainActor
class InsightViewModel: ObservableObject {
    @Published var todayInsight: InvestInsight?
    @Published var allInsights: [InvestInsight] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loadingStep = ""

    @AppStorage("newsAPIKey") private var newsAPIKey = ""
    @AppStorage("claudeAPIKey") private var claudeAPIKey = ""

    private let newsService = NewsAPIService()
    private let claudeService = ClaudeAPIService()
    private let store = InsightStore.shared

    init() {
        loadFromStorage()
    }

    func loadFromStorage() {
        allInsights = store.load()
        todayInsight = store.todayInsight()
    }

    func fetchTodayInsight() async {
        if todayInsight != nil { return }
        await refresh()
    }

    func refresh() async {
        isLoading = true
        errorMessage = nil

        do {
            loadingStep = "Fetching today's financial news..."
            let articles = try await newsService.fetchInvestmentNews(apiKey: newsAPIKey)

            loadingStep = "Claude is selecting the best insight..."
            let curated = try await claudeService.curateInsight(from: articles, apiKey: claudeAPIKey)

            let insight = InvestInsight(
                date: store.todayString(),
                title: curated.title,
                summary: curated.summary,
                chineseTitle: curated.chineseTitle,
                chineseSummary: curated.chineseSummary,
                originalTitle: curated.originalTitle,
                sourceURL: curated.sourceURL,
                sourceName: curated.sourceName
            )

            store.addInsight(insight)
            loadFromStorage()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        loadingStep = ""
    }

    var hasAPIKeys: Bool {
        !newsAPIKey.isEmpty && !claudeAPIKey.isEmpty
    }
}
