---
title: Documentation Sites
description: 文档平台连接器汇总
---

# Documentation Sites

## 概述

统一管理各类文档平台，覆盖知识库、在线文档、云盘、协作平台等。

## 连接器一览

| 连接器 | 平台 | 类型 | 主要能力 |
|---|---|---|---|
| `notion` | Notion | MCP | 页面/数据库 CRUD |
| `tencent-docs` | 腾讯文档 | MCP | 在线文档/表格/幻灯片 |
| `kdocs` | 金山文档 | MCP | WPS 云文档 |
| `lexiang` | 乐享知识库 | MCP | 企业知识库 |
| `iwiki-woa` | iWiki（司内版） | MCP | 司内 Wiki |
| `tapd` | TAPD | MCP | 敏捷协作/需求文档 |
| `baidu-netdisk` | 百度网盘 | MCP | 个人/企业网盘 |

## 目录结构

```
connectors/
├── notion/
├── tencent-docs/
├── kdocs/
├── lexiang/
├── iwiki-woa/
├── tapd/
└── baidu-netdisk/
```

## 通用配置模式

大部分文档平台 MCP 连接器使用标准 MCP URL 格式：

```json
{
    "mcpServers": {
        "PLATFORM_NAME": {
            "timeout": 600,
            "url": "https://api.platform.com/mcp"
        }
    }
}
```

## 平台详情

### Notion

| 变量名 | 说明 |
|---|---|
| `NOTION_API_KEY` | Notion Integration Token |
| `NOTION_DATABASE_ID` | 目标数据库 ID（如需） |

MCP URL: `https://api.notion.com/v1/integrations/{integration_token}`

### 腾讯文档（tencent-docs）

| 变量名 | 说明 |
|---|---|
| `TENCENT_DOCS_APP_ID` | 腾讯文档应用 ID |
| `TENCENT_DOCS_APP_SECRET` | 腾讯文档应用密钥 |

MCP URL: `https://docs.qq.com/openapi/mcp`

### 百度网盘（baidu-netdisk）

| 变量名 | 说明 |
|---|---|
| `BAIDU_NETDISK_ACCESS_TOKEN` | 百度网盘 Access Token |

> 百度网盘需要 OAuth2 授权流程获取 Access Token。

## 评估说明

当前正在评估腾讯文档作为公司 MKDOS 文档系统的替代方案：
- 优势：国内访问稳定，与企业微信/腾讯会议集成
- 挑战：API 限制较多，Markdown 格式兼容性
