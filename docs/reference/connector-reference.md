# Connector Reference

All connectors are stored under `connectors/`. Each connector is a folder containing at minimum a `mcp.json`.

## Env Var Reference

### baidu-netdisk

```bash
BAIDU_NETDISK_ACCESS_TOKEN=your_access_token
```

Obtain from: Baidu Open Platform → Pan API → Access Token

### gmail

```bash
EMAIL_USER=you@gmail.com
EMAIL_PASSWORD=your_app_password    # Not your account password — use an App Password
```

Obtain from: Google Account → Security → 2-Step Verification → App Passwords

### jira

```bash
JIRA_BASE_URL=https://your-domain.atlassian.net
JIRA_USERNAME=you@company.com
JIRA_API_TOKEN=your_api_token
```

Obtain from: Atlassian Account → Security → API Tokens

## Template-Only Connectors

These connectors use no env vars and are ready to use after bootstrap:

- dingtalk, edgeone-pages, fbs-connector, feishu, github, github-remote, gongfeng-woa, iwiki-woa, kdocs, lexiang, notion, qcc-company, qq-mail, supabase, tapd, tapd-woa, tencent-docs, tencent-survey, tencent-weiyun, tmeet, wecom, zhiyan-cicd
