---
title: Cloudflare
description: Cloudflare Workers / R2 / D1 / Pages 集成配置
---

# Cloudflare

## 概述

集成 Cloudflare 全栈能力，支持：
- **Workers**: 无服务器边缘函数
- **R2**: 对象存储（兼容 S3 API）
- **D1**: 边缘数据库（SQLite）
- **Pages**: 静态网站部署
- **WARP / Zero Trust**: 安全接入
- **Images / Stream**: 媒体处理

## 前置要求

1. Cloudflare 账号
2. 生成 API Token
3. 获取 Account ID（在 Cloudflare Dashboard 主页可见）

## 连接器文件

```
connectors/
├── cloudflare/          # Cloudflare 主连接器（新增）
│   ├── mcp.json
│   └── SKILL.md
└── edgeone-pages/       # 腾讯 EdgeOne Pages（已有）
    ├── mcp.json
    └── SKILL.md
```

## 环境变量

| 变量名 | 说明 |
|---|---|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API Token |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare Account ID |
| `CLOUDFLARE_ZONE_ID` | Cloudflare Zone ID（可选，域名管理用） |

## MCP 配置

```json
{
    "mcpServers": {
        "cloudflare": {
            "timeout": 600,
            "command": "npx",
            "args": ["-y", "@cloudflare/mcp@latest"],
            "env": {
                "CLOUDFLARE_API_TOKEN": "${CLOUDFLARE_API_TOKEN}",
                "CLOUDFLARE_ACCOUNT_ID": "${CLOUDFLARE_ACCOUNT_ID}"
            }
        }
    }
}
```

## 参考资料

- [Cloudflare MCP Server](https://developers.cloudflare.com/cloudflare-one/)
- [Cloudflare Workers 文档](https://developers.cloudflare.com/workers/)
- [Cloudflare R2 API](https://developers.cloudflare.com/r2/api/)
