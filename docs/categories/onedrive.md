---
title: OneDrive
description: Microsoft OneDrive 个人版/企业版云存储集成
---

# OneDrive

## 概述

通过 Microsoft Graph API 管理 OneDrive 个人版和企业版（OneDrive for Business），支持：
- 文件上传/下载/同步
- 跨账户文件合并
- 共享链接管理
- 版本历史查询
- 批量操作

## 前置要求

1. Microsoft 账号（个人）或 Azure AD 账号（企业）
2. Azure AD 应用注册（若用于企业版）
3. 获取 OAuth2 访问令牌

## 连接器文件

```
connectors/
└── onedrive/
    ├── mcp.json
    └── SKILL.md
```

## 环境变量

### 个人版（Personal）

| 变量名 | 说明 |
|---|---|
| `MSGRAPH_CLIENT_ID` | Azure AD 应用客户端 ID |
| `MSGRAPH_CLIENT_SECRET` | Azure AD 应用客户端密钥 |
| `MSGRAPH_TENANT_ID` | Azure AD 租户 ID |
| `ONEDRIVE_USER_EMAIL` | 绑定的 OneDrive 账户邮箱 |

### 企业版（OneDrive for Business）

| 变量名 | 说明 |
|---|---|
| `ODFB_TENANT_ID` | SharePoint 租户 ID |
| `ODFB_SITE_ID` | SharePoint Site ID |
| `ODFB_CLIENT_ID` | Azure AD 应用客户端 ID |
| `ODFB_CLIENT_SECRET` | Azure AD 应用客户端密钥 |

## Graph API 端点

```
https://graph.microsoft.com/v1.0/me/drive        # 个人 OneDrive
https://graph.microsoft.com/v1.0/sites/{site-id}/drive  # SharePoint/企业 OneDrive
```

## 跨账户合并策略

当需要在多个 OneDrive 账户间合并大文件/照片时：
1. 依次对每个账户获取 `access_token`
2. 使用 Graph API 批量查询文件列表
3. 按文件 Hash（`file.hashes.sha256`）去重
4. 通过 ShareLink 或 Direct Upload 合并

## 参考资料

- [Microsoft Graph OneDrive API](https://learn.microsoft.com/en-us/graph/api/driveitem)
- [Microsoft Graph 认证](https://learn.microsoft.com/en-us/graph/auth/)
