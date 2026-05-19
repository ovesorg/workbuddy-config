---
name: workspace-mcp
description: "WorkBuddy 工作区 MCP 服务器 — 通过本地 Node.js MCP Server 访问 D:\\github 工作区元数据、repo manifest、工具索引"
description_zh: "workspace-mcp 提供工作区范围的代码搜索、manifest 读取、repo registry 查询能力"
description_en: "Workspace MCP server for discovering repo manifests, tool registries, and workspace metadata across D:\\github"
version: 1.0.0
allowed-tools: Read,Bash,WebFetch
---

# workspace-mcp Skill

workspace-mcp 是 OVES 工作区的本地 MCP 服务器，运行在 `D:\github\workspace-mcp\server\src\server.js`。

## 能力

- **Repo Manifest 读取**：每个 repo 的 `docs/agent/manifest.yaml` 描述了资源位置和 authority 规则
- **Workspace Registry**：自动维护 `workspace-repo-registry.generated.json`，包含所有 repos 的元数据
- **工具索引**：通过 `workspace-tool-registry.json` 和 `workspace-toolset-catalog.json` 发现可用脚本和工具
- **Federated Discovery**：agent 不需要克隆 repo，通过 MCP 即可获取 repo 结构概览

## 前置要求

- Node.js 18+
- `npm install` 已在 `D:\github\workspace-mcp\server/` 执行
- WorkBuddy 环境变量 `WORKSPACE_ROOT=D:\github`

## 连接配置

```json
{
    "mcpServers": {
        "workspace-mcp": {
            "type": "stdio",
            "command": "node",
            "args": ["D:\\github\\workspace-mcp\\server\\src\\server.js"],
            "env": {
                "WORKSPACE_ROOT": "D:\\github"
            }
        }
    }
}
```

## 本地启动

```bash
cd D:\github\workspace-mcp\server
npm install
node .\src\server.js
```

## 与其他 Connectors 的关系

| Connector | 范围 | 用途 |
|---|---|---|
| workspace-mcp | 工作区全局 | 发现、搜索、读取 manifest |
| github | 单个 repo | Git 操作、PR、Issues |
| github-remote | 远程 API | 通过 GitHub API 查询 |
| cloudflare | 特定平台 | Cloudflare 全栈服务管理 |

## Repo Manifest Schema

每个 repo 的 `docs/agent/manifest.yaml` 是 AI agent 的入口契约：

```yaml
schema_version: "1.0"
kind: "repo_manifest"
repo_id: "repo-name"
repo_class: "shared-tooling"      # shared-tooling | dirac-* | oves-*
lifecycle: "active"
authority_order:
  - repo_owner_rules
  - template_standard
  - contract_spec
  - operational_guidance
  - historical_experience
entrypoints:
  - "docs/agent/start-here.md"
  - "docs/context/capabilities.md"
resource_roots:
  connectors: "connectors"
  skills: "skills"
  specs: "docs/context"
components:
  - id: "component-name"
    labels: ["workbuddy", "connectors"]
    paths:
      configs: "connectors"
```

## WorkBuddy Config Repo 的 Manifest

workbuddy-config 的 manifest 定义了以下 authority_order：

1. `repo_owner_rules` — Huashan Wang 的个人配置优先
2. `template_standard` — mkdocs-template 标准
3. `contract_spec` — MCP connector 契约
4. `operational_guidance` — bootstrap 脚本和 workflows
5. `historical_experience` — ADR 决策记录

## 相关文档

- 工作区架构：`D:\github\workspace-mcp\WORKSPACE_MCP_ARCHITECTURE.md`
- 工具目录：`D:\github\workspace-mcp\workspace-tool-registry.json`
- Repo Registry：`D:\github\workspace-mcp\workspace-repo-registry.generated.json`
