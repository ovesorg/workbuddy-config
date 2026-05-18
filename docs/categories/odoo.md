---
title: Odoo
description: Odoo ERP 集成配置
---

# Odoo

## 概述

通过 Odoo XML-RPC / JSON-RPC API 集成 Odoo ERP，支持：
- CRM（客户管理）
- 销售订单管理
- 库存/仓库管理
- 财务模块
- 自定义模块操作

## 前置要求

1. Odoo 实例（自部署或 Odoo Online）
2. API 用户账号（建议使用专用 API Key）
3. 启用 API 访问权限

## 连接器文件

```
connectors/
└── odoo/
    ├── mcp.json
    └── SKILL.md
```

## 环境变量

| 变量名 | 说明 |
|---|---|
| `ODOO_URL` | Odoo 实例 URL（如 `https://your-company.odoo.com`） |
| `ODOO_DB` | 数据库名称 |
| `ODOO_USERNAME` | API 用户名 |
| `ODOO_API_KEY` | API 密钥（Settings → Security → API Key） |

## 参考资料

- [Odoo API 文档](https://www.odoo.com/documentation/18.0/developer/reference.html)
- [Odoo XML-RPC 指南](https://www.odoo.com/documentation/18.0/developer/reference.html#web-services-xmlrpc)
