---
name: ms-teams
description: "Microsoft Teams / Azure AD 集成 - 通过 Microsoft Graph API 管理 Teams 消息、会议、文件和日历"
description_zh: "Microsoft Teams 和 Azure AD 集成，通过 Graph API 操作 Teams 消息、会议、文件"
description_en: "Microsoft Teams and Azure AD integration via Microsoft Graph API"
version: 1.0.0
allowed-tools: Read,Write,Bash,WebFetch
---

# MS Teams Skill

通过 Microsoft Graph API 与 Microsoft Teams 交互。

## 能力

- 读取/发送 Teams 频道消息
- 创建/管理 Teams 会议
- 访问 OneDrive / SharePoint 文件
- 查询 Azure AD 用户目录

## 前置要求

1. Azure AD 应用注册（portal.azure.com）
2. 开通 Graph API 权限
3. 配置环境变量

## 依赖连接器

`ms-teams` MCP Server
