---
title: Social Platforms
description: 企业社交/协作平台连接器汇总
---

# Social Platforms

## 概述

统一管理企业社交/协作平台，覆盖消息、通讯录、会议、日程等能力。

## 连接器一览

| 连接器 | 平台 | 类型 | 主要能力 |
|---|---|---|---|
| `wecom` | 企业微信 | MCP | 消息、应用管理 |
| `dingtalk` | 钉钉 | CLI | 消息、审批、考勤 |
| `feishu` | 飞书 | MCP | 消息、文档、会议 |
| `gongfeng-woa` | 纷云（企业微信） | MCP | 纷享销客 CRM |
| `tmeet` | 腾讯会议 | MCP | 会议创建、管理 |

## 目录结构

```
connectors/
├── wecom/
├── dingtalk/
├── feishu/
├── gongfeng-woa/
└── tmeet/
```

## 企业微信（wecom）

### 环境变量

| 变量名 | 说明 |
|---|---|
| `WECOM_CORP_ID` | 企业 ID |
| `WECOM_AGENT_ID` | 应用 Agent ID |
| `WECOM_AGENT_SECRET` | 应用 Secret |

## 钉钉（dingtalk）

使用 `dingtalk-workspace-cli`，通过 `cli.json` 配置：

```json
{
    "runtime": { "type": "node", "version": ">=16" },
    "init": { "win32": "npm install -g dingtalk-workspace-cli" },
    "auth": { "win32": "dws.cmd auth login -y" },
    "authUrlDomain": "login.dingtalk.com"
}
```

### 环境变量

| 变量名 | 说明 |
|---|---|
| `DINGTALK_APP_KEY` | 应用 App Key |
| `DINGTALK_APP_SECRET` | 应用 App Secret |

## 飞书（feishu）

### 环境变量

| 变量名 | 说明 |
|---|---|
| `FEISHU_APP_ID` | 飞书应用 App ID |
| `FEISHU_APP_SECRET` | 飞书应用 App Secret |

## 腾讯会议（tmeet）

### 环境变量

| 变量名 | 说明 |
|---|---|
| `TMEET_API_KEY` | 腾讯会议 API Key |
| `TMEET_API_SECRET` | 腾讯会议 API Secret |
