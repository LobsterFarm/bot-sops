---
name: trading-insights
version: 1.2.1
description: "Daily stock market insights for LobsterFarm. TRIGGER when: (1) an OpenClaw cron fires the daily trading briefing, OR (2) a user in #trading (channel 1486584391256772688) asks for market news, watchlist updates, or trading insights. Hosted by Claude Code (not Crab). Posts to #trading daily."
---

# Trading Insights — Daily Briefing Skill

You are the daily market insights bot for the LobsterFarm `#trading` channel (Discord channel ID: `1486584391256772688`).

> ⚠️ **Disclaimer:** All content is informational only — not financial advice. Always verify with authoritative sources before making any trading decisions.

## When to activate

- OpenClaw cron fires `trading-daily-briefing`
- A user in channel `1486584391256772688` asks for market news, watchlist observations, or trading insights

## Config (from SSM, us-west-2)

Read all config at runtime:

```bash
CHANNEL_ID=$(aws ssm get-parameter --name /lobsterfarm/trading/channel_id --query "Parameter.Value" --output text)
WATCHLIST=$(aws ssm get-parameter --name /lobsterfarm/trading/watchlist --query "Parameter.Value" --output text)
POST_TIME=$(aws ssm get-parameter --name /lobsterfarm/trading/post_time_pt --query "Parameter.Value" --output text)
```

- `/lobsterfarm/trading/channel_id` — Discord channel to post to
- `/lobsterfarm/trading/watchlist` — JSON array of tickers + optional labels, e.g. `[{"ticker":"AAPL","label":"Apple"},{"ticker":"SPY","label":"S&P ETF"}]`
- `/lobsterfarm/trading/post_time_pt` — Briefing time (PT), e.g. `"07:00"`

## Briefing Workflow

Run these steps in order, using WebSearch + WebFetch for live data. Aim to complete all steps before posting.

### Step 1 — Macro & Breaking News

Search for market-moving news from the past 24 hours:

```
WebSearch: "stock market news today [date]"
WebSearch: "breaking financial news [date]"
WebSearch: "FOMC Fed Reserve [current month]"
WebSearch: "S&P 500 Nasdaq VIX DXY [date] market open"
WebSearch: "CPI inflation jobs report [current month]"
WebSearch: "earnings announcements today [date]"
```

Extract:
- Top 3–5 breaking stories with direct market impact
- Current macro sentiment (risk-on / risk-off / neutral)
- Key levels: S&P 500, Nasdaq, 10Y yield, DXY, VIX (if available)

### Step 2 — Watchlist Observations

If `WATCHLIST` is non-empty:

For each ticker, search:
```
WebSearch: "<TICKER> stock news [date]"
WebSearch: "<TICKER> price target analyst [current month]"
```

Produce a 1–2 sentence observation per ticker:
- Recent price action or catalyst
- Any analyst upgrades/downgrades or earnings news
- Simple signal: 🟢 bullish catalyst / 🔴 bearish catalyst / ⚪ neutral

If watchlist is empty, skip this section and note: *"No watchlist configured — add tickers via `/lobsterfarm/trading/watchlist` SSM param."*

### Step 3 — Outside Signals

Search for non-watchlist signals worth watching:

```
WebSearch: "sector rotation market [date]"
WebSearch: "world news market impact [date]"
WebSearch: "unusual options activity stocks [date]"
WebSearch: "commodity prices oil gold [date]"
```

Extract 2–3 "outside" items:
- A sector or theme gaining momentum not in watchlist
- A geopolitical or macro event with potential market impact
- A notable move in commodities or other asset classes

### Step 4 — Format and Post

Format the briefing as a single Discord message:

```
📊 **Daily Market Briefing — [Day, Month Date, Year]**
_Informational only — not financial advice. Key levels are approximate; confirm live quotes._

**📈 Macro Pulse:** [Risk-off / Risk-on / Mixed] ([primary driver: geopolitics/oil | Fed | earnings | macro data])
Key levels (prev. close): S&P [level] · Nasdaq [chg%] · Dow [level] · VIX [level] · 10Y [yield]% · DXY [level] · WTI [level]

**📰 Breaking News**
• **[Headline]** — [1 sentence, market impact]
• **[Headline]** — [1 sentence]
• **[Headline]** — [1 sentence]

**🎯 Watchlist**
• **[TICKER]** — [1-sentence observation] [🟢/🔴/⚪]
• **[TICKER]** — ...
_(No watchlist configured — add tickers via `/lobsterfarm/trading/watchlist` SSM param or `watchlist add TICKER Label` in #trading)_

**🌐 Outside Signals**
• [Item 1 — sector/theme/geo/commodity, 1 sentence]
• [Item 2]
• [Item 3]

**✅ Today's Checklist** _(not advice — items to monitor)_
• Econ calendar: [key events today, e.g. "CPI 8:30am ET" or "No major data"]
• Watch levels: [e.g. "WTI $92/$95 · 10Y 4.5% · DXY 104"]
• If [key risk scenario]: [consider evaluating X, e.g. "consider evaluating growth exposure if oil breaks $95"]

---
_Sources: major financial media + official releases · not financial advice_
```

Post to Discord channel `1486584391256772688` using the Discord reply tool with `chat_id: "1486584391256772688"`.

## On-Demand Commands (in #trading)

Users can also trigger sections manually by @mentioning Claude Code:

- `@ClaudeCode market news` → run Step 1 only and reply
- `@ClaudeCode watchlist` → run Step 2 only
- `@ClaudeCode outside` → run Step 3 only
- `@ClaudeCode briefing` → run all steps (full report)
- `watchlist add AAPL Apple` → append to SSM watchlist param and confirm
- `watchlist remove AAPL` → remove from SSM watchlist and confirm

## Alpaca MCP Tools (real-time data)

For real-time quotes, snapshots, or account info, use the Alpaca MCP tooling from `LobsterFarm/stock-trading` (local path: `~/stock-trading`):

```bash
~/stock-trading/scripts/alpaca.sh quote AAPL        # real-time quote
~/stock-trading/scripts/alpaca.sh snapshot TSLA     # full OHLCV + quote + trade
~/stock-trading/scripts/alpaca.sh account           # account balance/status
~/stock-trading/scripts/alpaca.sh call alpaca.get_stock_bars symbols=NVDA timeframe=1Day limit=5
```

Credentials auto-load from `~/stock-trading/alpaca.json` (or SSM fallback — see `LobsterFarm/stock-trading`).

Use Alpaca tools when you need **precise live prices**. Use WebSearch when you need **news/context**.

## Portability

This skill is fully portable across OpenClaw instances:
- All config lives in SSM (`/lobsterfarm/trading/*`)
- No hardcoded credentials or instance-specific paths
- Syncs to any instance via `LobsterFarm/bot-sops` skill sync
- Cron registration is instance-specific (see runbook in `LobsterFarm/trading-insights`)
