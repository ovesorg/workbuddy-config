# Facebook Page Connector

MCP server for automating Facebook Page operations via the Graph API.

## Prerequisites

- Python package: `facebook-mcp-server` (already installed)
- Facebook Page access token with `pages_manage_posts`, `pages_read_engagement` permissions
- Page ID

## MCP Config

Add to `~/.workbuddy/mcp.json`:

```json
{
  "mcpServers": {
    "facebook": {
      "command": "C:/Users/Huashan_Wang/.workbuddy/binaries/python/versions/3.13.12/Scripts/facebook-mcp-server.exe",
      "timeout": 600,
      "env": {
        "FACEBOOK_ACCESS_TOKEN": "<your-page-access-token>",
        "FACEBOOK_PAGE_ID": "<your-page-id>"
      }
    }
  }
}
```

> **Multiple pages?** Create separate entries (`facebook-tz`, `facebook-ke`, etc.) with different env vars.

## Available Tools

| Tool | Description |
|---|---|
| `facebook_post_create` | Create a new post on the Page |
| `facebook_post_list` | List recent posts |
| `facebook_post_delete` | Delete a post |
| `facebook_comment_list` | List comments on a post |
| `facebook_comment_reply` | Reply to a comment |
| `facebook_page_info` | Get Page metadata |

## Token Setup

1. Go to [Facebook Developers](https://developers.facebook.com)
2. Create app → Add **Facebook Login** + **Pages API**
3. Generate **Page Access Token** (not User token)
4. Required permissions: `pages_manage_posts`, `pages_read_engagement`, `pages_show_list`

## Troubleshooting

| Error | Fix |
|---|---|
| `(#200) The user hasn't authorized the application` | Token missing required permissions |
| `Invalid OAuth access token` | Token expired or wrong Page ID |
| `MCP server not found` | Run: `python -m pip install facebook-mcp-server` |
