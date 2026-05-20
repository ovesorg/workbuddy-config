# Douyin 抖音企业号 Connector

## 连接类型

> ⚠️ **手动管理（无官方 MCP）** — 抖音目前没有公开的 Model Context Protocol (MCP) 服务器。
> 账号运营通过官方 App（抖音）和网页平台（创作者中心、巨量引擎）手动执行。
> WorkBuddy 通过 `douyin-account-setup` 和 `douyin-creator-tools` skill 提供操作指引。

## 相关 Skills

| Skill | 覆盖范围 |
|---|---|
| `douyin-account-setup` | 蓝V注册、认证、资料配置 |
| `douyin-creator-tools` | 创作者中心、热点宝、DOU+、剪映 |

Skill 路径：`~/.workbuddy/skills/douyin-*/`

## 平台访问

| 平台 | URL |
|---|---|
| 创作者中心 | https://creator.douyin.com |
| 巨量引擎（广告） | https://business.douyin.com |
| 抖音开放平台 | https://open.douyin.com |
| 热点宝 | 创作者中心 → 功能中心 → 热点宝 |

## 蓝V认证状态检查

```
1. 打开 https://creator.douyin.com
2. 登录企业账号
3. 进入「认证中心」
4. 确认蓝V徽章已激活
5. 如未激活 → 参考 douyin-account-setup skill
```

## 若未来引入 MCP

抖音开放平台（open.douyin.com）提供 REST API，但目前：
- 无官方 MCP Server
- 无社区主流 MCP 实现
- 如需 API 自动化，需申请 **抖音开放平台开发者权限**，走企业认证流程

如计划接入，参考：
- https://open.douyin.com/platform/overview
- 需要 AppID + AppSecret（企业认证后申请）
