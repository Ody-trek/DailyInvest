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
            .navigationTitle("Today's Insight")
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
            Text("API Keys Required")
                .font(.headline)
            Text("Please go to Settings and enter your NewsAPI and Claude API keys.")
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
            Text("Failed to Load")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
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
            Text("No insight yet for today")
                .font(.headline)
            Button("Fetch Now") {
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
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}
