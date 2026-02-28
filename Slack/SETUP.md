# Filo Design Request Bot — Setup Guide

A Slack bot that accepts design requests via DM, creates Jira tickets, generates design docs, and crossposts to `#filo-design-requests`.

---

## Prerequisites

- IT approval for a custom Slack app (Socket Mode, no public URL needed)
- Jira API token
- OpenAI API key
- Python 3.11+

---

## Step 1: Create the Slack App

1. Go to [api.slack.com/apps](https://api.slack.com/apps)
2. Click **Create New App** → **From scratch**
3. Name: `Filo Design Bot`
4. Workspace: XD Inc.

### Enable Socket Mode

1. Left sidebar → **Settings → Socket Mode**
2. Toggle **Enable Socket Mode** → ON
3. Create an app-level token with scope `connections:write`
4. Copy the `xapp-...` token → this is your `SLACK_APP_TOKEN`

### Bot Token Scopes

Left sidebar → **OAuth & Permissions** → **Scopes** → add these **Bot Token Scopes**:

| Scope | Why |
|-------|-----|
| `im:history` | Read DMs to the bot |
| `im:read` | Access DM channel info |
| `im:write` | Send replies in DMs |
| `chat:write` | Post summaries to #filo-design-requests |
| `users:read` | Get submitter display names |
| `channels:read` | Find #filo-design-requests channel ID |

### Event Subscriptions

Left sidebar → **Event Subscriptions** → toggle ON → under **Subscribe to bot events**, add:

| Event | Why |
|-------|-----|
| `message.im` | Triggers when someone DMs the bot |

### App Home

Left sidebar → **App Home**:
- Toggle **Messages Tab** → ON
- Check **Allow users to send Slash commands and messages from the messages tab**

### Install the App

1. Left sidebar → **Install App** → click **Install to Workspace**
2. Authorize the permissions
3. Copy the `xoxb-...` token → this is your `SLACK_BOT_TOKEN`

---

## Step 2: Get API Tokens

### Jira API Token

1. Go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Click **Create API token** → label it `Filo Design Bot`
3. Copy the token → this is your `JIRA_API_TOKEN`

### OpenAI API Key

1. Go to [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. Create a new key → this is your `OPENAI_API_KEY`

---

## Step 3: Configure and Run

```bash
cd Slack

# Copy env template
cp .env.example .env

# Fill in your tokens in .env (use any text editor)

# Install dependencies
pip install -r requirements.txt

# Run the bot
export $(cat .env | xargs) && python bot.py
```

You should see: `Starting Filo Design Request Bot...`

---

## Step 4: Create the Channel

1. Create `#filo-design-requests` if it doesn't exist
2. Invite the bot: `/invite @Filo Design Bot`
3. Pin an instructions message:

> **How to submit a design request**
>
> DM `@Filo Design Bot` with your request in plain language (EN or CH).
>
> Describe:
> - **What** you need
> - **Why** it matters
> - **Which platform** (iOS, Mac, etc.) if relevant
>
> The bot will create a Jira ticket and confirm back to you.
>
> ---
>
> **如何提交设计需求**
>
> 直接私信 `@Filo Design Bot`，用中文或英文描述你的需求。
>
> 请说明：
> - 你需要**什么**
> - **为什么**重要
> - 涉及**哪个平台**（iOS、Mac 等）
>
> 机器人会自动创建 Jira 工单并回复确认。

---

## How It Works

```
Person DMs @Filo Design Bot
  ↓
AI parses message (GPT-4o-mini, handles EN/CH)
  ↓
Valid request?
  No  → Replies with a friendly nudge to add more detail
  Yes → Creates Jira ticket (FILO project, assigned to LiangXi)
          ↓
        Generates design doc → Request/Todo/[FILO-XXXX] - Title.md
          ↓
        Replies in DM with Jira link + confirmation
          ↓
        Crossposts summary to #filo-design-requests
          ↓
        Awaits triage via Cursor (jira-ticket-triage skill)
```

---

## Keeping It Running

### Option A: tmux (simplest)
```bash
tmux new -s filo-bot
export $(cat .env | xargs) && python bot.py
# Ctrl+B then D to detach
```

### Option B: launchd (macOS, auto-restart)
Create `~/Library/LaunchAgents/com.filo.design-bot.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.filo.design-bot</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/env</string>
        <string>bash</string>
        <string>-c</string>
        <string>cd /Users/connieliang/Desktop/Filo/Slack && export $(cat .env | xargs) && python bot.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/filo-bot.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/filo-bot.err</string>
</dict>
</plist>
```

Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.filo.design-bot.plist
```

### Option C: Deploy to server
For team-wide reliability: Fly.io, Railway, or a company VPS.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Bot doesn't respond to DMs | Check App Home → Messages Tab is ON |
| "not_in_channel" for crosspost | Invite bot to #filo-design-requests |
| Jira ticket creation fails | Verify JIRA_EMAIL + JIRA_API_TOKEN in .env |
| OpenAI parsing fails | Check OPENAI_API_KEY and billing status |
| Bot responds to itself | Already handled — bot messages have `bot_id` and are ignored |
| Duplicate tickets | Already handled — bot tracks processed message timestamps |
