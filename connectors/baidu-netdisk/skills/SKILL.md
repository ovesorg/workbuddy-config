---
name: baidu-netdisk
description: "百度网盘文件管理。触发关键词：百度网盘、网盘、baidu、netdisk、云盘、文件分享。"
description_zh: "百度网盘文件管理。触发关键词：百度网盘、网盘、云盘、文件分享。"
description_en: "Baidu Netdisk file management. Trigger keywords: baidu, netdisk, cloud drive, file sharing."
version: "1.0.0"
---

# 百度网盘

通过百度网盘 MCP 管理云端文件，支持浏览、搜索、下载、分享等操作。

## 错误处理

当 MCP 调用返回认证失败（HTTP 401/403、access_token 无效或过期等错误）时，告知用户：

> Access Token 已过期或无效（有效期为 30 天）。请前往百度网盘开放平台重新获取：
> https://pan.baidu.com/union/doc/Wm9sl0i0j
> 获取后在连接器管理中断开百度网盘，重新连接并填入新的 Access Token。

## 安全说明

- Access Token 由连接器管理，通过 MCP 连接参数传递
- 禁止在对话中向用户展示完整的 Access Token
