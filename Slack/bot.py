"""
Filo Design Request Bot

People DM this bot with design/feature requests in plain language (EN or CH).
The bot:
1. Parses the message using AI into structured data
2. Creates a Jira ticket in the FILO project, assigned to LiangXi
3. Generates a design doc in Request/Todo/
4. Replies in DM with confirmation
5. Crossposts a summary to #filo-design-requests
"""

from __future__ import annotations

import os
import re
import json
import logging
from datetime import datetime
from pathlib import Path

import requests
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
from openai import OpenAI

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

SLACK_BOT_TOKEN = os.environ["SLACK_BOT_TOKEN"]
SLACK_APP_TOKEN = os.environ["SLACK_APP_TOKEN"]
JIRA_BASE_URL = os.environ.get("JIRA_BASE_URL", "https://xindong.atlassian.net")
JIRA_EMAIL = os.environ["JIRA_EMAIL"]
JIRA_API_TOKEN = os.environ["JIRA_API_TOKEN"]
JIRA_PROJECT_KEY = os.environ.get("JIRA_PROJECT_KEY", "FILO")
OPENAI_API_KEY = os.environ["OPENAI_API_KEY"]
REQUEST_DIR = os.environ.get(
    "REQUEST_DIR",
    str(Path(__file__).resolve().parent.parent / "Request"),
)
DESIGN_CHANNEL = os.environ.get("DESIGN_CHANNEL", "filo-design-requests")
LIANG_XI_ACCOUNT_ID = "712020:b6ab84a3-3c60-4c99-b2a1-140bfb9bb75a"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("filo-design-bot")

app = App(token=SLACK_BOT_TOKEN)
openai_client = OpenAI(api_key=OPENAI_API_KEY)

# Track processed messages to avoid duplicates
processed_timestamps: set[str] = set()

# ---------------------------------------------------------------------------
# AI: Parse natural-language message into a structured request
# ---------------------------------------------------------------------------

PARSE_SYSTEM_PROMPT = """\
You are a request parser for Filo, an AI-native email client.
Given a Slack DM, extract a structured design/feature request.

Return JSON only, no markdown fences:
{
  "title": "Short English title (prefix with platform tag if mentioned, e.g. 【iOS】)",
  "title_zh": "Short Chinese title if the message is in Chinese, else null",
  "description": "Clean description of what is being requested and why",
  "platform": "ios | mac | android | multi | unknown",
  "priority": "high | medium | low",
  "is_valid_request": true/false,
  "language": "en | zh",
  "rejection_reason": "If not a valid request, explain why (null otherwise)"
}

A message is NOT a valid request if it's:
- Casual chat, greetings, or off-topic (e.g. "hi", "hello", "thanks")
- Too vague to act on (e.g. "make it better", "improve the app")
- A question rather than a request (e.g. "how does X work?")
- Just a single word or emoji

Be generous — if someone describes a problem or pain point, that counts as a request.
Default priority to "medium" unless urgency is explicitly stated.
"""


def parse_request(message_text: str, author_name: str) -> dict:
    """Use LLM to parse a Slack message into a structured request."""
    response = openai_client.chat.completions.create(
        model="gpt-4o-mini",
        temperature=0,
        messages=[
            {"role": "system", "content": PARSE_SYSTEM_PROMPT},
            {
                "role": "user",
                "content": f"Author: {author_name}\nMessage:\n{message_text}",
            },
        ],
    )
    raw = response.choices[0].message.content.strip()
    # Strip markdown fences if the model adds them anyway
    raw = re.sub(r"^```(?:json)?\s*", "", raw)
    raw = re.sub(r"\s*```$", "", raw)
    return json.loads(raw)


# ---------------------------------------------------------------------------
# Jira: Create a ticket
# ---------------------------------------------------------------------------


def create_jira_ticket(
    title: str, description: str, priority: str, reporter_name: str
) -> dict:
    """Create a Jira issue in the FILO project and return the response."""
    priority_map = {"high": "2", "medium": "3", "low": "4"}

    full_description = (
        f"{description}\n\n---\nSubmitted by {reporter_name} via Slack DM"
    )

    url = f"{JIRA_BASE_URL}/rest/api/3/issue"
    payload = {
        "fields": {
            "project": {"key": JIRA_PROJECT_KEY},
            "summary": title,
            "description": {
                "type": "doc",
                "version": 1,
                "content": [
                    {
                        "type": "paragraph",
                        "content": [{"type": "text", "text": full_description}],
                    }
                ],
            },
            "issuetype": {"name": "Task"},
            "priority": {"id": priority_map.get(priority, "3")},
            "assignee": {"accountId": LIANG_XI_ACCOUNT_ID},
        }
    }
    resp = requests.post(
        url,
        json=payload,
        auth=(JIRA_EMAIL, JIRA_API_TOKEN),
        headers={"Content-Type": "application/json"},
        timeout=30,
    )
    resp.raise_for_status()
    return resp.json()


# ---------------------------------------------------------------------------
# Docs: Generate a design request document
# ---------------------------------------------------------------------------


def generate_doc(
    ticket_key: str,
    title: str,
    title_zh: str | None,
    description: str,
    platform: str,
    priority: str,
    reporter: str,
) -> Path:
    """Create a markdown design doc in Request/Todo/."""
    todo_dir = Path(REQUEST_DIR) / "Todo"
    todo_dir.mkdir(parents=True, exist_ok=True)

    safe_title = re.sub(r'[<>:"/\\|?*]', "", title)[:60]
    filename = f"{ticket_key} - {safe_title}.md"
    filepath = todo_dir / filename

    platform_display = {
        "ios": "iOS",
        "mac": "macOS",
        "android": "Android",
        "multi": "iOS, macOS, Android",
        "unknown": "TBD",
    }.get(platform, "TBD")

    zh_line = f"\n> {title_zh}\n" if title_zh else ""

    content = f"""# {ticket_key} — {title}
{zh_line}
| Field | Value |
|-------|-------|
| Jira | [{ticket_key}]({JIRA_BASE_URL}/browse/{ticket_key}) |
| Reporter | {reporter} |
| Status | Open |
| Priority | {priority.capitalize()} |
| Platforms | {platform_display} |
| Source | Slack DM |
| Created | {datetime.now().strftime("%Y-%m-%d")} |

---

## Request

{description}

---

## Triage

Pending review against Filo product principles. This document was auto-generated from a Slack DM request.

---

## Open Questions

- [ ] To be filled after triage

---

## Next Steps

1. Triage against Filo product principles
2. If approved, flesh out design direction
3. If rejected, comment on Jira ticket with reasoning
"""
    filepath.write_text(content, encoding="utf-8")
    return filepath


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def find_channel_id(client, channel_name: str) -> str | None:
    """Find a channel ID by name. Returns None if not found."""
    try:
        cursor = None
        while True:
            kwargs = {"types": "public_channel", "limit": 200}
            if cursor:
                kwargs["cursor"] = cursor
            result = client.conversations_list(**kwargs)
            for channel in result["channels"]:
                if channel["name"] == channel_name:
                    return channel["id"]
            cursor = result.get("response_metadata", {}).get("next_cursor")
            if not cursor:
                break
    except Exception as e:
        logger.error(f"Failed to find channel {channel_name}: {e}")
    return None


# ---------------------------------------------------------------------------
# Slack: Listen for DMs
# ---------------------------------------------------------------------------

REPLY_INVALID_EN = (
    "This doesn't look like a design request. "
    "Could you describe *what* feature or change you need and *why*?\n\n"
    "Example: _\"The inbox on iOS needs swipe-to-archive. "
    "Right now users have to open each email to archive it, which is slow.\"_"
)

REPLY_INVALID_ZH = (
    "这看起来不像一个设计需求。"
    "能描述一下你需要*什么*功能或改动，以及*为什么*吗？\n\n"
    "示例：_\"iOS 端的收件箱需要左滑归档功能。"
    "现在用户得打开每封邮件才能归档，太慢了。\"_"
)


@app.event("message")
def handle_dm(event, say, client):
    """Process DMs sent to the bot."""
    # Only handle direct messages (im), ignore channels
    if event.get("channel_type") != "im":
        return

    # Ignore bot messages, edits, deletions, thread replies
    if event.get("subtype") or event.get("bot_id") or event.get("thread_ts"):
        return

    # Deduplicate
    ts = event.get("ts", "")
    if ts in processed_timestamps:
        return
    processed_timestamps.add(ts)
    # Keep the set from growing unbounded
    if len(processed_timestamps) > 10000:
        processed_timestamps.clear()

    message_text = event.get("text", "").strip()
    user_id = event.get("user", "")

    if not message_text:
        return

    # Get the author's display name
    try:
        user_info = client.users_info(user=user_id)
        author_name = user_info["user"].get(
            "real_name", user_info["user"].get("name", "Unknown")
        )
    except Exception:
        author_name = "Unknown"

    # --- Parse the message ---
    try:
        parsed = parse_request(message_text, author_name)
    except Exception as e:
        logger.error(f"Failed to parse message from {author_name}: {e}")
        say(
            text="Something went wrong parsing your request. Please try again.",
            channel=event["channel"],
        )
        return

    # --- Handle invalid requests ---
    if not parsed.get("is_valid_request"):
        lang = parsed.get("language", "en")
        reply = REPLY_INVALID_ZH if lang == "zh" else REPLY_INVALID_EN
        say(text=reply, channel=event["channel"])
        logger.info(
            f"Invalid request from {author_name}: {parsed.get('rejection_reason')}"
        )
        return

    # --- Create Jira ticket ---
    try:
        jira_resp = create_jira_ticket(
            title=parsed["title"],
            description=parsed["description"],
            priority=parsed["priority"],
            reporter_name=author_name,
        )
        ticket_key = jira_resp["key"]
        ticket_url = f"{JIRA_BASE_URL}/browse/{ticket_key}"
    except Exception as e:
        logger.error(f"Failed to create Jira ticket: {e}")
        say(
            text=f"Failed to create Jira ticket. Error: {e}",
            channel=event["channel"],
        )
        return

    # --- Generate design doc ---
    doc_name = "(doc generation failed)"
    try:
        doc_path = generate_doc(
            ticket_key=ticket_key,
            title=parsed["title"],
            title_zh=parsed.get("title_zh"),
            description=parsed["description"],
            platform=parsed["platform"],
            priority=parsed["priority"],
            reporter=author_name,
        )
        doc_name = doc_path.name
    except Exception as e:
        logger.error(f"Failed to generate doc: {e}")

    # --- Reply in DM ---
    lang = parsed.get("language", "en")
    if lang == "zh":
        dm_reply = (
            f"已收到你的需求。\n\n"
            f"*Jira:* <{ticket_url}|{ticket_key}>\n"
            f"*标题:* {parsed['title']}\n"
            f"*平台:* {parsed['platform']}\n"
            f"*优先级:* {parsed['priority']}\n"
            f"*文档:* `Request/Todo/{doc_name}`\n\n"
            f"_将根据 Filo 产品原则进行评审。_"
        )
    else:
        dm_reply = (
            f"Got it. Request logged.\n\n"
            f"*Jira:* <{ticket_url}|{ticket_key}>\n"
            f"*Title:* {parsed['title']}\n"
            f"*Platform:* {parsed['platform']}\n"
            f"*Priority:* {parsed['priority']}\n"
            f"*Doc:* `Request/Todo/{doc_name}`\n\n"
            f"_Pending triage against Filo product principles._"
        )

    say(text=dm_reply, channel=event["channel"])

    # --- Crosspost to #filo-design-requests ---
    try:
        channel_id = find_channel_id(client, DESIGN_CHANNEL)
        if channel_id:
            zh_title = (
                f" ({parsed['title_zh']})" if parsed.get("title_zh") else ""
            )
            client.chat_postMessage(
                channel=channel_id,
                text=(
                    f"*New design request* via Slack DM\n\n"
                    f"*Jira:* <{ticket_url}|{ticket_key}>\n"
                    f"*Title:* {parsed['title']}{zh_title}\n"
                    f"*Platform:* {parsed['platform']}\n"
                    f"*Priority:* {parsed['priority']}\n"
                    f"*Submitted by:* {author_name}\n\n"
                    f"_{parsed['description'][:200]}{'...' if len(parsed['description']) > 200 else ''}_"
                ),
            )
        else:
            logger.warning(
                f"Channel #{DESIGN_CHANNEL} not found. Skipping crosspost."
            )
    except Exception as e:
        logger.error(f"Failed to crosspost to #{DESIGN_CHANNEL}: {e}")

    logger.info(f"Processed request from {author_name} -> {ticket_key}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    logger.info("Starting Filo Design Request Bot...")
    handler = SocketModeHandler(app, SLACK_APP_TOKEN)
    handler.start()
