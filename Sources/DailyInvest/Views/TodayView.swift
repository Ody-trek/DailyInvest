import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: InsightViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    dateHeader
                    content
                }
                .padding()
            }
            .navigationTitle("今日投资洞察")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
        }
        .task {
            await viewModel.fetchTodayInsight()
        }
    }

    private var dateHeader: some View {
        HStack {
            Text(formattedDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }

    private var content: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if !viewModel.hasAPIKeys {
                missingKeysView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if let insight = viewModel.todayInsight {
                InsightCardView(insight: insight)
            } else {
                emptyView
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(viewModel.loadingStep)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private var missingKeysView: some View {
        VStack(spacing: 12) {
            Image(systemName: "key.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            Text("需要配置 API Key")
                .font(.headline)
            Text("请前往「设置」页面填写 NewsAPI 和 Claude API Key")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text("获取失败")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("重试") {
                Task { await viewModel.refresh() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "newspaper")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("今日洞察还未生成")
                .font(.headline)
            Button("立即获取") {
                Task { await viewModel.refresh() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }

    private var refreshButton: some View {
        Button {
            Task { await viewModel.refresh() }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(viewModel.isLoading)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: Date())
    }
}
