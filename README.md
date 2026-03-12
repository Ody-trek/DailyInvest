# DailyInvest

One AI-curated investment insight every day, powered by Claude AI and global financial news.

**English UI · 中文内容同步提供** — The app displays in English by default. Tap the **中文** button on any insight card to switch to the Chinese version.

## Features

- **Today's Insight** — Automatically fetches financial news via NewsAPI and lets Claude AI select the single most valuable piece for investors, with a concise English summary
- **中文切换** — Every insight card has a language toggle: tap to read the Chinese title and summary, tap again to return to English
- **History** — Browse all past insights; each entry shows both the English headline and Chinese title at a glance
- **Fully local** — API keys are stored only on your device; no data passes through any third-party server

## Screenshots

> *(Add after running the app)*

## Quick Start

### Prerequisites

- macOS 13+ with Xcode 15+
- iOS 16+ device or simulator
- [NewsAPI Key](https://newsapi.org/register) (free tier available)
- [Claude API Key](https://console.anthropic.com/)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ody-trek/DailyInvest.git
   cd DailyInvest
   ```

2. **Create an Xcode project**
   - Open Xcode → File → New → Project
   - Choose **iOS → App**
   - Product Name: `DailyInvest`, Interface: **SwiftUI**, Language: **Swift**
   - Uncheck Core Data and Tests

3. **Add source files**
   - Drag all `.swift` files from `Sources/DailyInvest/` into Xcode
   - Delete the default `ContentView.swift` Xcode generated (this repo provides one)

4. **Allow network requests** in `Info.plist`
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

5. **Run** — Open Settings tab, enter your API keys, then tap refresh on Today's tab

## Project Structure

```
Sources/DailyInvest/
├── DailyInvestApp.swift          # App entry point
├── Models/
│   ├── InvestInsight.swift       # Bilingual insight model (EN + 中文)
│   └── NewsArticle.swift         # NewsAPI response model
├── Services/
│   ├── NewsAPIService.swift      # Fetch financial news
│   └── ClaudeAPIService.swift    # Claude AI: select & summarise in EN + 中文
├── ViewModels/
│   └── InsightViewModel.swift    # Business logic
├── Views/
│   ├── ContentView.swift         # Tab container
│   ├── TodayView.swift           # Today's insight (English UI)
│   ├── InsightCardView.swift     # Card with EN ↔ 中文 toggle
│   ├── HistoryView.swift         # Past insights list
│   └── SettingsView.swift        # API key configuration
└── Storage/
    └── InsightStore.swift        # Local JSON persistence
```

## How It Works

```
App opens
    ↓
Check local storage for today's insight
    ↓  (not found)
Fetch up to 20 financial news articles via NewsAPI
    ↓
Send articles to Claude (claude-opus-4-6)
Claude picks the most valuable one and returns:
  • English title + summary
  • 中文标题 + 投资洞察
    ↓
Save locally → display on Today tab
User can tap 中文 to toggle language on the insight card
```

## Tech Stack

- **UI**: SwiftUI (iOS 16+)
- **Networking**: URLSession — no third-party dependencies
- **Storage**: UserDefaults (API keys) + JSON file (history)
- **AI**: Claude claude-opus-4-6 via [Anthropic API](https://www.anthropic.com/)
- **News**: [NewsAPI](https://newsapi.org/)

## Contributing

Issues and PRs are welcome!

## License

MIT
