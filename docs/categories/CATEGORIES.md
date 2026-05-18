---
title: 配置分类概览
description: WorkBuddy Config 仓库中 6 大目标分类的完整映射
---

# 6 大目标分类

本文档说明 `workbuddy-config` 仓库的 6 大目标分类，以及每个分类下的连接器配置方式。

---

## 1. MS Teams (Azure)

**目标**：通过 Microsoft Graph API / Azure AD 集成 Teams 消息、日历、文件等能力。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `ms-teams` | **新增** | MCP | Microsoft Graph API MCP |

### 配置方式

```json
// connectors/ms-teams/mcp.json
{
    "mcpServers": {
        "ms-teams": {
            "timeout": 600,
            "url": "https://YOUR_TEAM.cognitivemicrosoft.com/mcp"
        }
    }
}
```

> 需要 Azure AD 应用注册，配置 `CLIENT_ID`, `CLIENT_SECRET`, `TENANT_ID` 环境变量。

---

## 2. Odoo

**目标**：通过 Odoo XML-RPC / JSON-RPC API 管理 Odoo ERP 的CRM、销售、库存等模块。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `odoo` | **新增** | REST/XML-RPC | Odoo 标准 API |

### 配置方式

```json
// connectors/odoo/mcp.json
{
    "mcpServers": {
        "odoo": {
            "timeout": 600,
            "url": "https://YOUR_ODOO_INSTANCE/jsonrpc"
        }
    }
}
```

> 需要 Odoo 数据库 URL、用户名和 API Key。

---

## 3. CloudFlare

**目标**：管理 Cloudflare Workers、R2 存储、D1 数据库、Pages 部署等。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `cloudflare` | **新增** | MCP | Cloudflare API MCP |
| `edgeone-pages` | 已有 | MCP | EdgeOne Pages（腾讯云 EdgeOne） |

### 配置方式

```json
// connectors/cloudflare/mcp.json
{
    "mcpServers": {
        "cloudflare": {
            "timeout": 600,
            "command": "npx",
            "args": ["-y", "@cloudflare/mcp@latest"]
        }
    }
}
```

> 需要 Cloudflare API Token（Account ID, API Token）。

---

## 4. Social Platforms

**目标**：统一管理企业社交/协作平台的消息、通讯录、群组等。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `wecom` | 已有 | MCP | 企业微信 |
| `dingtalk` | 已有 | CLI | 钉钉 |
| `feishu` | 已有 | MCP | 飞书 |
| `gongfeng-woa` | 已有 | MCP | 纷云（企微第三方） |
| `tmeet` | 已有 | MCP | 腾讯会议 |

### 配置方式

各平台独立配置，详见各连接器目录下的 `mcp.json` / `cli.json`。

---

## 5. OneDrive

**目标**：通过 Microsoft Graph API 管理 OneDrive 个人/企业版文件的云端访问、同步策略。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `onedrive` | **新增** | MCP | Microsoft Graph API（OneDrive 专用端点） |

### 配置方式

```json
// connectors/onedrive/mcp.json
{
    "mcpServers": {
        "onedrive": {
            "timeout": 600,
            "url": "https://graph.microsoft.com/v1.0"
        }
    }
}
```

> 需要 Microsoft Graph OAuth2 应用注册（`CLIENT_ID`, `CLIENT_SECRET`, `TENANT_ID`）。

---

## 6. Documentation Sites

**目标**：统一管理各类文档平台（Notion、腾讯文档、金山文档、飞书知识库等）。

### 连接器

| 连接器 | 状态 | 类型 | 说明 |
|---|---|---|---|
| `notion` | 已有 | MCP | Notion |
| `tencent-docs` | 已有 | MCP | 腾讯文档 |
| `kdocs` | 已有 | MCP | 金山文档 |
| `lexiang` | 已有 | MCP | 乐享知识库 |
| `iwiki-woa` | 已有 | MCP | iWiki（司内版） |
| `tapd` | 已有 | MCP | TAPD（腾讯敏捷协作平台） |
| `baidu-netdisk` | 已有 | MCP | 百度网盘 |

### 配置方式

各平台独立配置，详见各连接器目录下的 `mcp.json`。

---

## 分类索引

- [MS Teams (Azure)](ms-teams.md)
- [Odoo](odoo.md)
- [CloudFlare](cloudflare.md)
- [Social Platforms](social-platforms.md)
- [OneDrive](onedrive.md)
- [Documentation Sites](documentation-sites.md)
