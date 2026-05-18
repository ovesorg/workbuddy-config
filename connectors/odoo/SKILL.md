---
name: odoo
description: "Odoo ERP 集成 - 通过 XML-RPC/JSON-RPC API 管理 Odoo CRM、销售、库存等模块"
description_zh: "Odoo ERP 系统集成，管理 CRM、销售、库存、财务等业务模块"
description_en: "Odoo ERP integration for CRM, Sales, Inventory, and Finance management"
version: 1.0.0
allowed-tools: Read,Write,Bash,WebFetch
---

# Odoo Skill

通过 Odoo XML-RPC / JSON-RPC API 与 Odoo ERP 交互。

## 能力

- CRM 客户管理（创建/查询商机）
- 销售订单 CRUD
- 库存/仓库操作
- 财务数据查询
- 自定义模块操作

## 前置要求

1. Odoo 实例 URL（自部署或 Odoo Online）
2. API 用户账号 + API Key
3. 开通 API 访问权限

## 依赖连接器

`odoo` MCP Server

## 常用模型

| 模型 | 说明 |
|---|---|
| `crm.lead` | CRM 商机 |
| `sale.order` | 销售订单 |
| `stock.picking` | 库存调拨 |
| `account.move` | 财务凭证 |
| `res.partner` | 合作伙伴 |
