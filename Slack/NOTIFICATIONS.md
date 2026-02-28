# Notification Setup — Ticket Assigned to LiangXi

Three notification channels: Slack (real-time DM), Email (real-time), Cursor (on session start).

---

## 1. Slack — Real-time DM Notifications

The Jira Cloud for Slack app (already installed in your workspace) can DM you when tickets are assigned to you.

### Setup Steps

1. **Open a DM with the Jira Cloud bot**
   - In Slack, search for "Jira Cloud" in your DMs or type `/jira`

2. **Connect your Jira account**
   ```
   /jira connect
   ```
   Follow the OAuth flow to link your Jira account (liangxi@xd.com)

3. **Enable personal notifications**
   ```
   /jira notifications
   ```
   Or go to: **Jira Cloud app → Home tab → Notifications → Configure**

4. **Turn on "Assigned to me"**
   - Toggle ON: **An issue is assigned to me**
   - Optional: also toggle **An issue I'm watching is updated** and **Someone comments on my issue**

That's it. You'll get a Slack DM every time a ticket is assigned to you.

### What the DM Looks Like

> **FILO-1234** was assigned to you
> *Summary:* 【iOS】New feature request
> *Priority:* Medium
> *Reporter:* 黄小文 HuangXiaowen
> [View in Jira →]

---

## 2. Email — Real-time Notifications (liangxi@xd.com)

Jira sends email notifications by default. Verify it's enabled:

### Check Your Jira Notification Settings

1. Go to: https://xindong.atlassian.net
2. Click your avatar (top-right) → **Personal settings** (or **Manage account**)
3. Go to **Email** → **Notification preferences**
4. Make sure these are ON:
   - **Assigned** — When an issue is assigned to you
   - **Updated** — When an issue assigned to you is updated
   - **Commented** — When someone comments on your issue

### If emails aren't arriving

- Check spam/junk folder for emails from `noreply@atlassian.com`
- Ask your Jira admin if the notification scheme for the FILO project includes assignment notifications
- Verify your email is set to `liangxi@xd.com` in Jira profile

---

## 3. Cursor — Auto-check on Session Start

Already configured in `.cursorrules`. Every time you start a new Cursor conversation in the Filo project, the agent will:

1. Automatically pull recent Jira tickets assigned to you
2. Report any new or updated tickets
3. Flag items needing triage or with new comments

This isn't a real-time push notification (Cursor doesn't support that), but it guarantees you see updates the moment you open Cursor.

---

## Summary

| Channel | Type | Latency | Setup |
|---------|------|---------|-------|
| Slack DM | Push notification | Real-time | `/jira connect` → `/jira notifications` |
| Email | Push notification | Real-time | Verify Jira notification settings |
| Cursor | Pull on session start | On conversation start | Already configured in `.cursorrules` |
