---
name: onedrive
description: "Microsoft OneDrive 集成 - 通过 Graph API 管理个人/企业 OneDrive 文件、跨账户合并、批量操作"
description_zh: "Microsoft OneDrive 云存储集成，管理个人版和企业版的文件、跨账户合并、批量操作"
description_en: "Microsoft OneDrive integration via Graph API - file management, cross-account merge, batch operations"
version: 1.0.0
allowed-tools: Read,Write,Bash,WebFetch
---

# OneDrive Skill

通过 Microsoft Graph API 管理 OneDrive 文件存储。

## 能力

- 文件上传/下载/删除
- 跨多个 OneDrive 账户合并文件（按 SHA256 Hash 去重）
- 共享链接（ShareLink）管理
- 版本历史查询
- 批量文件操作
- 文件夹结构整理

## 前置要求

1. Azure AD 应用注册
2. Microsoft Graph 权限开通：
   - `Files.ReadWrite.All`
   - `Sites.ReadWrite.All`
3. 目标账户 OAuth2 授权

## 依赖连接器

`onedrive` MCP Server

## 跨账户合并流程

1. 依次获取每个 OneDrive 账户的 `access_token`
2. 调用 `/me/drive/root/children` 列出所有文件
3. 对每个文件获取 `file.hashes.sha256` 作为唯一标识
4. 按 Hash 分组，保留最大版本或最新修改
5. 通过 ShareLink 或 Direct Upload 合并到目标账户

## Graph API 端点

| 端点 | 用途 |
|---|---|
| `GET /me/drive` | 当前用户 OneDrive 信息 |
| `GET /me/drive/root/children` | 根目录文件列表 |
| `GET /me/drive/items/{id}` | 获取文件元数据 |
| `POST /me/drive/root/children` | 上传文件 |
| `DELETE /me/drive/items/{id}` | 删除文件 |
