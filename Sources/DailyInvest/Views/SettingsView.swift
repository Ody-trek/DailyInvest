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
            .navigationTitle("设置")
        }
    }

    private var apiKeysSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Label("NewsAPI Key", systemImage: "newspaper")
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack {
                    Group {
                        if showNewsAPIKey {
                            TextField("粘贴你的 NewsAPI Key", text: $newsAPIKey)
                        } else {
                            SecureField("粘贴你的 NewsAPI Key", text: $newsAPIKey)
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
                    Label("已配置", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 8) {
                Label("Claude API Key", systemImage: "cpu")
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack {
                    Group {
                        if showClaudeAPIKey {
                            TextField("粘贴你的 Claude API Key", text: $claudeAPIKey)
                        } else {
                            SecureField("粘贴你的 Claude API Key", text: $claudeAPIKey)
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
                    Label("已配置", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("API 配置")
        } footer: {
            Text("API Key 仅保存在你的设备本地，不会上传到任何服务器。")
        }
    }

    private var linksSection: some View {
        Section("获取 API Key") {
            Link(destination: URL(string: "https://newsapi.org/register")!) {
                Label("注册 NewsAPI（免费）", systemImage: "arrow.up.right.square")
            }
            Link(destination: URL(string: "https://console.anthropic.com/")!) {
                Label("获取 Claude API Key", systemImage: "arrow.up.right.square")
            }
        }
    }

    private var aboutSection: some View {
        Section("关于") {
            LabeledContent("版本", value: "1.0.0")
            Link(destination: URL(string: "https://github.com/Ody-trek/DailyInvest")!) {
                Label("GitHub 开源地址", systemImage: "chevron.left.slash.chevron.right")
            }
        }
    }
}
