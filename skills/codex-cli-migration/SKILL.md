---
name: codex-cli-migration
description: 将Codex CLI工作流迁移到WorkBuddy的完整指南。此技能在以下场景触发：用户询问如何从Codex CLI过渡到WorkBuddy，需要并行终端策略，寻求命令映射，或希望优化现有命令行工作流。包含常见使用模式对照表、迁移步骤、示例脚本和最佳实践。
metadata:
  agent_created: true
---

# Codex CLI 迁移指南

## 概述

本技能提供将Codex CLI工作流迁移到WorkBuddy的全面指南。Codex CLI是OpenAI的命令行界面工具，用于AI代码生成和交互，而WorkBuddy是集成了AI助手、任务管理、文件操作和多代理协作的开发环境。

当用户需要：
- 了解WorkBuddy如何替代Codex CLI功能
- 迁移现有命令行工作流
- 管理并行终端会话
- 优化开发工作流
- 保留熟悉命令的同时获得增强功能

应使用此技能。

## 核心概念映射

### Codex CLI vs WorkBuddy 能力对比

| Codex CLI 功能 | WorkBuddy 对应方案 | 优势 |
|----------------|-------------------|------|
| **命令行AI交互** | 直接与WorkBuddy对话 | 上下文感知、记忆保持、项目感知 |
| `codex <prompt>` | 向WorkBuddy提问 | 无需安装配置、内置工具链 |
| **多终端窗口** | `run_in_background` + 多Bash调用 | 统一管理、输出可检索 |
| **脚本执行** | Bash/PowerShell工具 | 沙箱安全、自动记录 |
| **临时上下文** | 工作记忆 + 项目记忆 | 跨会话持久化、可搜索 |
| **手动笔记** | 自动记忆写入 | 结构化存储、关联任务 |

## 迁移工作流

### 第1步：识别现有使用模式

分析当前Codex CLI使用场景：

1. **快速问答**：`codex "如何修复这个bug?"`
2. **代码生成**：`codex "写一个Python函数处理CSV"`
3. **交互式会话**：持续对话模式
4. **多任务并行**：多个终端窗口运行不同命令
5. **脚本自动化**：将codex命令嵌入脚本

### 第2步：WorkBuddy实现策略

针对每种模式的具体迁移方案：

#### 模式1：快速问答 → 直接对话
- **Codex CLI**：`codex "解释React Hooks"`
- **WorkBuddy**：直接提问"解释React Hooks"
- **增强功能**：可要求生成代码示例、图表说明或逐步教程

#### 模式2：代码生成 → 集成编辑
- **Codex CLI**：`codex "创建Express.js API端点" > api.js`
- **WorkBuddy**：
  1. 请求"创建Express.js API端点"
  2. 使用Write工具直接写入文件
  3. 使用Bash工具测试运行
- **增强功能**：自动生成测试、文档、错误处理

#### 模式3：交互式会话 → 上下文保持
- **Codex CLI**：多次`codex`调用，上下文有限
- **WorkBuddy**：单次对话，全程上下文保持
- **增强功能**：工作记忆自动记录、任务跟踪

#### 模式4：多终端并行 → 并发执行
- **Codex CLI**：打开多个终端窗口
- **WorkBuddy**：
  ```bash
  # 方案A：后台任务
  Bash(command="长时间任务", run_in_background=true)
  
  # 方案B：并发调用（同消息多个Bash工具）
  Bash(command="任务1")
  Bash(command="任务2")
  
  # 方案C：子代理委托
  Agent(description="探索代码库", subagent_type="Explore", prompt="搜索API端点")
  ```
- **增强功能**：任务状态监控、输出聚合

### 第3步：高级迁移场景

#### 场景A：CI/CD流水线中的Codex CLI
- **原命令**：`codex "生成部署脚本"`
- **迁移方案**：
  1. 创建Skill封装部署脚本生成逻辑
  2. 设置Automation定时运行
  3. 使用GitHub MCP直接操作仓库

#### 场景B：团队共享的Codex命令
- **原命令**：团队文档中的`codex`命令集
- **迁移方案**：
  1. 创建团队共享的Project Skill
  2. 封装常用命令序列
  3. 添加使用示例和最佳实践

#### 场景C：复杂多步工作流
- **原流程**：终端1监控 + 终端2构建 + 终端3测试
- **WorkBuddy方案**：
  ```bash
  # 步骤1：启动监控（后台）
  Bash(command="tail -f logs/app.log", run_in_background=true)
  
  # 步骤2：并发构建和测试
  Bash(command="npm run build")
  Bash(command="npm test")
  
  # 步骤3：结果汇总
  TaskUpdate(status="completed")
  ```

## 命令映射参考

### 常用Codex CLI命令及对应WorkBuddy实现

#### AI代码生成
```
codex "写一个Python FastAPI服务"
↓
直接请求："创建一个Python FastAPI服务，包含/user和/products端点"
```

#### 代码解释
```
codex "解释这段TypeScript泛型代码"
↓
提供代码片段，询问："请解释这段TypeScript泛型代码的工作原理"
```

#### 错误诊断
```
codex "为什么这个Dockerfile构建失败？"
↓
粘贴错误信息，询问："分析这个Docker构建错误的原因和解决方案"
```

#### 文档生成
```
codex "为这个函数写文档字符串"
↓
提供函数代码，请求："为这个函数生成完整的文档字符串，包含参数说明和示例"
```

### 保留Codex CLI作为后备

如果仍需使用Codex CLI：
```bash
# 通过WorkBuddy的Bash工具调用
Bash(command="codex '生成一个React组件'")
```

## 并行执行策略

### 策略1：后台任务 + 轮询
```bash
# 启动长时间任务
Bash(command="npm run dev", run_in_background=true)

# 稍后检查状态
Bash(command="ps aux | grep node")
```

### 策略2：多工具并发调用
```bash
# 在同一消息中并发执行
Bash(command="git status")
Bash(command="npm run lint")
Bash(command="docker ps")
```

### 策略3：子代理分工
```bash
# 主代理专注于核心任务
# 启动探索代理处理文件搜索
Agent(
  description="搜索代码库",
  subagent_type="Explore",
  prompt="查找所有使用useEffect的React组件"
)
```

### 策略4：任务协调
```bash
# 使用TaskCreate/TaskUpdate管理并行工作流
TaskCreate(subject="运行测试套件", description="执行单元测试和集成测试")
TaskCreate(subject="构建项目", description="编译TypeScript和打包")
# 标记任务状态，系统自动协调
```

## 技能与自动化

### 封装常用工作流为Skill

示例：创建"api-endpoint-generator" Skill
```yaml
# SKILL.md节选
## 生成REST API端点
1. 询问用户端点详情（资源、方法、字段）
2. 生成Express.js路由代码
3. 创建对应的模型和验证
4. 生成Swagger文档
5. 写入项目文件
```

### 设置定时Automation

```bash
# 每日代码质量检查
automation_update(
  name="每日代码审查",
  prompt="运行ESLint、TypeScript编译和测试，报告问题",
  scheduleType="recurring",
  rrule="FREQ=DAILY;BYHOUR=9;BYMINUTE=0"
)
```

## 最佳实践

### 迁移阶段建议
1. **渐进迁移**：先从非关键任务开始
2. **双重运行**：初期同时使用Codex CLI和WorkBuddy对比
3. **收集反馈**：记录迁移中的痛点，优化技能
4. **团队培训**：如果是团队使用，创建培训材料

### 性能优化
1. **上下文管理**：定期清理不需要的上下文
2. **技能模块化**：创建专注的小技能而非庞大单体
3. **记忆策略**：重要决策写入MEMORY.md，临时信息写入每日日志
4. **代理选择**：简单搜索用Explore代理，复杂分析用Plan代理

### 错误处理
1. **Command失败**：检查命令语法、路径、权限
2. **代理超时**：设置合理的timeout参数
3. **上下文溢出**：使用references/目录存储大文档
4. **沙箱限制**：危险操作需要用户确认

## 故障排除

### 常见问题
1. **Codex CLI命令在WorkBuddy中失败**
   - 检查PATH配置：`Bash(command="which codex")`
   - 验证API密钥：确保Hunyuan或OpenAI配置正确
   - 测试命令：`Bash(command="codex --version")`

2. **并行执行混乱**
   - 使用TaskUpdate明确标记任务状态
   - 为后台任务添加描述性名称
   - 定期检查后台任务输出

3. **上下文丢失**
   - 确保重要信息写入记忆文件
   - 使用references/存储持久化文档
   - 在对话中引用之前的关键决策

4. **性能问题**
   - 减少同时活动的后台任务数量
   - 使用子代理处理重型搜索
   - 定期重启WorkBuddy会话清理内存

## 资源

### scripts/ 目录
包含实用迁移脚本：
- `migrate_codex_workflow.py`：分析codex历史并生成迁移建议
- `parallel_executor.sh`：并行执行命令的模板脚本
- `context_backup.py`：备份和恢复工作上下文

### references/ 目录
- `command_cheatsheet.md`：Codex CLI与WorkBuddy命令速查表
- `advanced_patterns.md`：高级并行模式和优化技巧
- `troubleshooting_guide.md`：详细故障排除指南

### assets/ 目录
- `workflow_templates/`：常用工作流模板文件
- `migration_checklist.md`：迁移进度检查清单
- `team_onboarding.pptx`：团队培训材料模板

## 后续步骤

1. **评估现有工作流**：识别最常使用的Codex CLI命令
2. **创建个性化技能**：基于常用模式定制技能
3. **设置关键自动化**：将重复任务转为Automation
4. **培训团队成员**：如果是团队环境，共享最佳实践
5. **持续优化**：根据使用反馈迭代技能内容

---

**提示**：此技能为动态文档，随着WorkBuddy功能更新和用户反馈，应定期更新内容。用户可随时请求修改或添加特定迁移场景。
