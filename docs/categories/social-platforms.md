---
title: Social Media Marketing
description: 社媒营销平台连接器与内容运营指南
---

# Social Media Marketing（社媒营销）

## 概述

面向海外受众与中国国内消费者的社媒营销平台覆盖，包括抖音企业号（Douyin）、Facebook、Instagram、LinkedIn 等平台的账号配置与内容运营工作流。

> **相关 Skills:** `douyin-account-setup`, `douyin-creator-tools`（位于 `~/.workbuddy/skills/`）

## 平台一览

| 平台 | 类型 | 受众 | 主要用途 |
|---|---|---|---|
| [Douyin 抖音](#douyin-抖音) | MCP / 手动 | 国内外消费者、供应商、投资者 | 品牌内容、供应链可视化 |
| `facebook` | MCP | 海外 B2B / B2C | 待接入 |
| `instagram` | MCP | 海外 B2C | 待接入 |
| `linkedin` | MCP | 海外 B2B 决策者、投资者 | 待接入 |
| `x-twitter` | MCP | 海外行业舆论 | 待接入 |

## 目录结构

```
connectors/
├── douyin/           ← 抖音企业号
├── facebook/         ← Facebook（待接入）
├── instagram/        ← Instagram（待接入）
├── linkedin/         ← LinkedIn（待接入）
└── x-twitter/       ← X / Twitter（待接入）
```

## Douyin 抖音

### 快速导航

| 资源 | 链接 |
|---|---|
| 创作者中心 | https://creator.douyin.com |
| 巨量引擎（广告平台） | https://business.douyin.com |
| 抖音开放平台 | https://open.douyin.com |
| 蓝V认证状态 | 创作者中心 → 认证中心 |

### 相关文档

- [Douyin 连接器配置](connectors/douyin/) — MCP 配置与环境变量
- `douyin-account-setup` skill — 账号注册与蓝V认证完整流程
- `douyin-creator-tools` skill — 创作者中心、热点宝、DOU+、剪映操作指南

### 目标受众说明

抖音企业号的受众分为三类，均需英文字幕支持：

| 受众 | 内容方向 |
|---|---|
| 供应商（国内） | 产能、供应链透明度、合作案例 |
| 投资者（海外） | 品牌故事、出口数据、市场地位 |
| 海外访客 | 工厂实拍、产品质量证明、制造业实力 |

### 蓝V认证前置条件

| 材料 | 说明 |
|---|---|
| 营业执照 | 统一社会信用代码清晰可见 |
| 法人代表身份证 | 正反面彩色扫描 |
| 授权书 | 巨量引擎下载模板，盖章签字 |

> 认证费用：**¥600/年**（内资企业）。审核周期 1–3 个工作日。

### 热点借势工作流

```
每日早晨 → 热点宝查看今日热度话题
         → 筛选与品牌相关的主题（1–2个）
         → 匹配内容 Pillar 进行创作
         → 使用热点 BGM + 热点标签
         → 发布后 30 分钟内回复评论
```

## 待接入平台

以下平台正在规划接入阶段：

- **Facebook / Instagram** — 海外 B2C 渠道，需 Meta Business 账号
- **LinkedIn** — 海外 B2B 渠道，需 LinkedIn Page + Sales Navigator
- **X / Twitter** — 行业舆论监控与品牌声量追踪

> 如需启动任意平台的接入流程，请告知。
