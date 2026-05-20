# WorkBuddy Setup — AI Agent 可读版

本文档面向 AI Agent，描述 WorkBuddy 的安装路径、环境变量、目录结构和 bootstrap 工作流，让 agent 能够在 `D:\github` 工作区内自主操作。

---

## 核心路径速查

| 用途 | Windows 路径 |
|---|---|
| WorkBuddy 程序安装 | `C:\Users\Huashan_Wang\AppData\Local\Programs\WorkBuddy` |
| 用户配置根目录 | `C:\Users\Huashan_Wang\.workbuddy` |
| 用户 Skills | `C:\Users\Huashan_Wang\.workbuddy\skills` |
| 用户 Connectors | `C:\Users\Huashan_Wang\.workbuddy\connectors-marketplace\connectors` |
| MCP 配置 | `C:\Users\Huashan_Wang\.workbuddy\.mcp.json` |
| 用户数据库 | `C:\Users\Huashan_Wang\.workbuddy\workbuddy.db` |
| 本次会话历史 | `C:\Users\Huashan_Wang\.workbuddy\projects` |

---

## MCP 配置格式

WorkBuddy 使用标准 MCP JSON 配置。以下是各种协议类型：

### stdio 类型（本地进程）

```json
{
  "mcpServers": {
    "my-connector": {
      "type": "stdio",
      "command": "node",
      "args": ["D:\\path\\to\\server.js"],
      "env": { "KEY": "value" }
    }
  }
}
```

### npx 类型（npm 包）

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

### streamable-http 类型（远程 API）

```json
{
  "mcpServers": {
    "github": {
      "type": "streamable-http",
      "url": "https://api.github.com/mcp",
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### CLI 类型

```json
{
  "mcpServers": {
    "wecom": {
      "command": "D:\\path\\to\\wecom-cli.exe",
      "args": ["mcp", "run"]
    }
  }
}
```

---

## 环境变量配置

WorkBuddy 在运行时读取环境变量并注入到 MCP Server。凭证**不**写入文件，统一用占位符：

```
${ENV_VAR_NAME}
```

### 常用环境变量（按 connector 分组）

#### Cloudflare

```bash
CLOUDFLARE_API_TOKEN=        # Dashboard → My Profile → API Tokens
CLOUDFLARE_ACCOUNT_ID=       # Workers & Pages → 任意 Worker 详情页顶部
```

#### MS Teams / Azure

```bash
MS_TENANT_ID=               # Azure Portal → Azure Active Directory → Tenant ID
MS_CLIENT_ID=               # Azure Portal → App Registrations → Client ID
MS_CLIENT_SECRET=           # Azure Portal → App Registrations → Client Secrets
```

#### Odoo

```bash
ODOO_URL=https://your-company.odoo.com
ODOO_DB=your_database_name
ODOO_USERNAME=admin@company.com
ODOO_API_KEY=               # Odoo → Settings → User Profile → API Key
```

#### OneDrive

```bash
ONEDRIVE_CLIENT_ID=         # Azure Portal → App Registrations
ONEDRIVE_CLIENT_SECRET=
```

#### GitHub

```bash
GITHUB_TOKEN=               # GitHub → Settings → Developer Settings → Personal Access Tokens
```

#### Jira

```bash
JIRA_BASE_URL=https://your-domain.atlassian.net
JIRA_USERNAME=you@company.com
JIRA_API_TOKEN=             # Atlassian Account → Security → API Tokens
```

#### Notion

```bash
NOTION_API_TOKEN=           # Notion → Settings → Integrations → Internal Integration Token
```

#### Email

```bash
EMAIL_USER=you@gmail.com
EMAIL_PASSWORD=            # Google Account → Security → App Passwords（不是登录密码）
```

---

## Bootstrap 工作流

### bootstrap.ps1（Windows）

```powershell
# 1. 克隆 workbuddy-config 到本地
git clone https://github.com/ovesorg/workbuddy-config.git D:\github\workbuddy-config

# 2. 运行 bootstrap（管理员 PowerShell）
.\scripts\bootstrap.ps1

# bootstrap.ps1 执行：
#   - 将 connectors/*/ 软链接到 ~/.workbuddy/connectors-marketplace/connectors/
#   - 将 skills/*/ 软链接到 ~/.workbuddy/skills/
#   - 读取环境变量模板，提示用户填写
#   - 重启 WorkBuddy 应用使配置生效
```

### 手动触发 bootstrap

```powershell
cd D:\github\workbuddy-config
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1
```

---

## .workbuddy 目录结构

```
~/.workbuddy/
├── .mcp.json                  ← MCP server 聚合配置（运行时生效）
├── workbuddy.db               ← SQLite：automation 调度状态、会话历史
├── skills/                    ← 用户级 Skills（所有 workspace 共享）
│   ├── automation-workflows/
│   ├── chatgpt/
│   ├── codex-cli-migration/
│   ├── doc-site-template/
│   ├── github/
│   ├── openclaw-odoo/
│   └── web3-graphql/
├── connectors-marketplace/
│   └── connectors/            ← 软链接到 workbuddy-config/connectors/
│       ├── cloudflare/
│       ├── github/
│       ├── ms-teams/
│       ├── odoo/
│       ├── onedrive/
│       ├── workspace-mcp/
│       └── ...
├── projects/                  ← 会话历史存档（每个会话一个目录）
│   └── 2026-05-18-task-10/
│       └── .workbuddy/
│           ├── memory/
│           │   ├── YYYY-MM-DD.md    ← 每日工作记录
│           │   └── MEMORY.md       ← 长期记忆
│           └── tasks/              ← 会话任务列表
└── teams/                    ← 多 agent 协作团队配置
```

---

## 对 AI Agent 的期望行为

### 工作记忆规则

1. **启动时**：读取 `~/.workbuddy/projects/<today>/.workbuddy/memory/` 中的 MEMORY.md 和今日日志
2. **重要决策后**：追加到 `~/.workbuddy/projects/<today>/.workbuddy/memory/YYYY-MM-DD.md`
3. **用户偏好**：写入 `~/.workbuddy/projects/<today>/.workbuddy/memory/MEMORY.md`

### Skill 积累规则

- 完成 8+ 步骤的多步任务后，将可复用的工作流保存为 Skill
- 使用 `SkillManage`（Skill 工具）创建或修改 Skill
- Skill 默认存放在 `~/.workbuddy/skills/`（user-level）
- 除非用户明确要求项目级共享，否则不用 `~/<repo>/.workbuddy/skills/`

### connector 发现流程

1. 检查 `~/.workbuddy/connectors-marketplace/connectors/` 中是否存在目标 connector
2. 若不存在，查阅 `D:\github\workbuddy-config\connectors\{name}\mcp.json` 确认模板
3. 确认凭证后，告知用户"请在 WorkBuddy 环境变量中配置 XXX"
4. **不要猜测**或硬编码凭证

---

## OVES 工作区特定上下文

### Workspace MCP

`workspace-mcp` 是工作区级别的 MCP Server，提供：

- `D:\github\workspace-repo-registry.generated.json` — 所有 repo 元数据索引
- `D:\github\workspace-tool-registry.json` — 工具脚本索引
- `D:\github\workspace-toolset-catalog.json` — 工具集目录
- 每个 repo 的 `docs/agent/manifest.yaml` — Agent 入口契约

### mkdocs-template Doc-Site 标准

OVES 所有文档站使用 `D:\github\mkdocs-template` 包管理，标准化三步流程：

```bash
mkdocs-oves-migrate .      # Step 1：迁移到包模式
mkdocs-oves-normalize .    # Step 2：标准化模板状态（PORT 参考见 skill）
mkdocs-oves-krr --port 8000 # Step 3：Kill, Rebuild, Re-serve
```

导航风格检查：不得使用 `navigation.tabs` 和 `navigation.sections`。

### 本地代理配置

```bash
http_proxy=http://127.0.0.1:10808
https_proxy=http://127.0.0.1:10808
```

---

## 连接状态参考

当前 WorkBuddy Desktop 已连接（2026-05-19）：

| Connector | 状态 |
|---|---|
| github | ✅ Connected |
| 其他 | ❌ Disconnected（待配置凭证） |

---

*本文档由 WorkBuddy Agent 自动维护，每次 bootstrap 后更新。*
