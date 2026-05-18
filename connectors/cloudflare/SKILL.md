---
name: cloudflare
description: "Cloudflare 全栈集成 - Workers/R2/D1/Pages/Images/Stream 等边缘计算和媒体服务"
description_zh: "Cloudflare 边缘计算平台集成，管理 Workers、R2 存储、D1 数据库、Pages 部署等"
description_en: "Cloudflare edge computing platform - Workers, R2 Storage, D1 Database, Pages, Images"
version: 1.0.0
allowed-tools: Read,Write,Bash,WebFetch
---

# Cloudflare Skill

通过 Cloudflare API MCP Server 管理 Cloudflare 全栈服务。

## 能力

- **Workers**: 部署/管理边缘无服务器函数
- **R2**: 对象存储（S3 兼容 API）
- **D1**: 边缘 SQLite 数据库
- **Pages**: 静态网站部署与构建
- **Images**: 图片处理与 CDN
- **Stream**: 视频处理与播放
- **Zero Trust**: 安全接入与访问策略
- **DNS**: 域名解析管理

## 前置要求

1. Cloudflare 账号
2. API Token（Account ID + API Token）
3. 目标 Account ID

## 依赖连接器

`cloudflare` MCP Server

## 与 EdgeOne 的区别

| 功能 | Cloudflare | EdgeOne Pages |
|---|---|---|
| 全球 CDN | 全球 300+ 节点 | 腾讯云国内节点 |
| Workers | ✅ 边缘计算 | ❌ 不支持 |
| R2 | ✅ S3 兼容存储 | 腾讯 COS |
| D1 | ✅ 边缘 SQLite | 腾讯 EdgeDB |
| Pages | ✅ 静态部署 | ✅ 静态部署 |
