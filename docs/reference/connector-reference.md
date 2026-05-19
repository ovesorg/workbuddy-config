# Connector Reference

All connectors are stored under `connectors/`. Each connector is a folder containing at minimum a `mcp.json` and a `SKILL.md`.

## Target Category Connectors

### cloudflare

```bash
CLOUDFLARE_API_TOKEN=your_api_token
CLOUDFLARE_ACCOUNT_ID=your_account_id
```

Obtain from: Cloudflare Dashboard → My Profile → API Tokens | Workers & Pages overview page

### ms-teams

```bash
MS_TENANT_ID=your_tenant_id
MS_CLIENT_ID=your_app_client_id
MS_CLIENT_SECRET=your_app_client_secret
```

Obtain from: Azure Portal → Azure Active Directory → App Registrations

### odoo

```bash
ODOO_URL=https://your-company.odoo.com
ODOO_DB=your_database_name
ODOO_USERNAME=admin@company.com
ODOO_API_KEY=your_api_key
```

Obtain from: Odoo → Settings → Users → Your Profile → API Key

### onedrive

```bash
ONEDRIVE_CLIENT_ID=your_app_client_id
ONEDRIVE_CLIENT_SECRET=your_app_client_secret
```

Obtain from: Azure Portal → Azure Active Directory → App Registrations → New Registration

### workspace-mcp

```bash
WORKSPACE_ROOT=D:\github
```

No secret required. This runs a local Node.js MCP server at `D:\github\workspace-mcp\server\src\server.js`.

## Development Connectors

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

### notion

```bash
NOTION_API_TOKEN=secret_xxxxxxxxxxxxxxxxxxxx
```

Obtain from: Notion → Settings → Integrations → Develop an integration → Internal Integration Token

## Template-Only Connectors

These connectors use no env vars and are ready to use after bootstrap:

baidu-netdisk, ctrip-wendao, dingtalk, edgeone-pages, fbs-connector, feishu, github, github-remote, gongfeng-woa, iwiki-woa, kdocs, lexiang, qcc-company, qq-mail, supabase, tapd, tapd-woa, tencent-docs, tencent-survey, tencent-weiyun, tmeet, wecom, zhiyan-cicd
