---
title: MS Teams (Azure)
description: Microsoft Teams / Azure AD 集成配置
---

# MS Teams (Azure)

## 概述

通过 Microsoft Graph API 集成 Microsoft Teams，支持：
- Teams 消息发送/读取
- 日历会议管理
- OneDrive/SharePoint 文件访问
- Azure AD 用户/组织管理

## 前置要求

1. Azure AD 应用注册
2. 开通以下 Graph API 权限：
   - `Team.ReadBasic.All`
   - `Channel.ReadBasic.All`
   - `Chat.Read`
   - `Calendars.ReadWrite`
   - `Files.ReadWrite.All`

## 连接器文件

```
connectors/
└── ms-teams/
    ├── mcp.json
    └── SKILL.md
```

## 环境变量

| 变量名 | 说明 |
|---|---|
| `AZURE_CLIENT_ID` | Azure AD 应用客户端 ID |
| `AZURE_CLIENT_SECRET` | Azure AD 应用客户端密钥 |
| `AZURE_TENANT_ID` | Azure AD 租户 ID |

## 参考资料

- [Microsoft Graph API 文档](https://learn.microsoft.com/en-us/graph/api/overview)
- [Azure AD 应用注册](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
