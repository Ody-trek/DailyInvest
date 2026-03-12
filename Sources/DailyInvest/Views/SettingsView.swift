import SwiftUI

struct SettingsView: View {
    @AppStorage("newsAPIKey") private var newsAPIKey = ""
    @AppStorage("claudeAPIKey") private var claudeAPIKey = ""

    @State private var showNewsAPIKey = false
    @State private var showClaudeAPIKey = false

    var body: some View {
        NavigationView {
            Form {
                apiKeysSection
                linksSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    private var apiKeysSection: some View {
        Section {
            // NewsAPI Key
            VStack(alignment: .leading, spacing: 8) {
                Label("NewsAPI Key", systemImage: "newspaper")
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack {
                    Group {
                        if showNewsAPIKey {
                            TextField("Paste your NewsAPI Key", text: $newsAPIKey)
                        } else {
                            SecureField("Paste your NewsAPI Key", text: $newsAPIKey)
                        }
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    Button {
                        showNewsAPIKey.toggle()
                    } label: {
                        Image(systemName: showNewsAPIKey ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                if !newsAPIKey.isEmpty {
                    Label("Configured", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)

            // Claude API Key
            VStack(alignment: .leading, spacing: 8) {
                Label("Claude API Key", systemImage: "cpu")
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack {
                    Group {
                        if showClaudeAPIKey {
                            TextField("Paste your Claude API Key", text: $claudeAPIKey)
                        } else {
                            SecureField("Paste your Claude API Key", text: $claudeAPIKey)
                        }
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    Button {
                        showClaudeAPIKey.toggle()
                    } label: {
                        Image(systemName: showClaudeAPIKey ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                if !claudeAPIKey.isEmpty {
                    Label("Configured", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("API Configuration")
        } footer: {
            Text("Keys are stored locally on your device only and never sent to any third-party server.")
        }
    }

    private var linksSection: some View {
        Section("Get API Keys") {
            Link(destination: URL(string: "https://newsapi.org/register")!) {
                Label("Register for NewsAPI (Free)", systemImage: "arrow.up.right.square")
            }
            Link(destination: URL(string: "https://console.anthropic.com/")!) {
                Label("Get Claude API Key", systemImage: "arrow.up.right.square")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version", value: "1.0.0")
            LabeledContent("Language", value: "English · 中文")
            Link(destination: URL(string: "https://github.com/Ody-trek/DailyInvest")!) {
                Label("View on GitHub", systemImage: "chevron.left.slash.chevron.right")
            }
        }
    }
}
