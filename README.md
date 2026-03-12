# DailyInvest

每天一条最有价值的投资洞察，由 Claude AI 从全球财经新闻中精选并提炼。

## 功能

- **今日洞察**：每天自动从 NewsAPI 抓取财经新闻，由 Claude AI 筛选出最有价值的一条，用中文进行投资解读
- **历史记录**：查看所有历史洞察，随时回顾
- **纯本地**：API Key 仅保存在设备本地，数据不经过任何第三方服务器

## 截图

> （运行后截图补充）

## 快速开始

### 前提条件

- macOS 13+ 和 Xcode 15+
- iOS 16+ 设备或模拟器
- [NewsAPI Key](https://newsapi.org/register)（免费）
- [Claude API Key](https://console.anthropic.com/)

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/your-username/DailyInvest.git
   cd DailyInvest
   ```

2. **在 Xcode 中创建项目**
   - 打开 Xcode → File → New → Project
   - 选择 **iOS → App**
   - Product Name: `DailyInvest`
   - Interface: **SwiftUI**，Language: **Swift**
   - 取消勾选 Core Data 和 Tests

3. **添加源文件**
   - 将 `Sources/DailyInvest/` 下的所有 `.swift` 文件拖入 Xcode 项目
   - 删除 Xcode 自动生成的 `ContentView.swift`（已由本项目提供）

4. **配置 Info.plist**（允许网络请求）

   在 Info.plist 中添加：
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

5. **运行 App**
   - 选择模拟器或连接真机，点击运行
   - 进入「设置」页面填写 NewsAPI Key 和 Claude API Key
   - 返回「今日」页面，点击刷新即可获取今日洞察

## 项目结构

```
Sources/DailyInvest/
├── DailyInvestApp.swift          # App 入口
├── Models/
│   ├── InvestInsight.swift       # 洞察数据模型
│   └── NewsArticle.swift         # NewsAPI 响应模型
├── Services/
│   ├── NewsAPIService.swift      # 抓取财经新闻
│   └── ClaudeAPIService.swift    # Claude AI 筛选提炼
├── ViewModels/
│   └── InsightViewModel.swift    # 业务逻辑
├── Views/
│   ├── ContentView.swift         # 主 Tab 容器
│   ├── TodayView.swift           # 今日洞察页
│   ├── InsightCardView.swift     # 洞察卡片组件
│   ├── HistoryView.swift         # 历史记录页
│   └── SettingsView.swift        # 设置页
└── Storage/
    └── InsightStore.swift        # 本地持久化
```

## 工作原理

```
用户打开 App
    ↓
检查本地是否有今天的洞察
    ↓ 没有
调用 NewsAPI 获取最新财经新闻（最多20条）
    ↓
将新闻列表发送给 Claude API
Claude 分析并选出最有投资价值的一条
返回中文标题 + 投资解读（100-150字）
    ↓
保存到本地，展示给用户
```

## 技术栈

- **UI**: SwiftUI
- **网络**: URLSession（原生，无第三方依赖）
- **存储**: UserDefaults（API Key）+ JSON 文件（历史记录）
- **AI**: Claude claude-opus-4-6 via Anthropic API
- **新闻**: NewsAPI

## 贡献

欢迎提 Issue 和 PR！

## License

MIT
