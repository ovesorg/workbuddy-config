# Codex CLI → WorkBuddy 命令速查表

## AI交互命令

### 基础问答
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "如何修复这个错误？"` | 直接提问"如何修复这个错误？" | 无需前置命令，直接对话 |
| `codex --model gpt-4 "解释这个概念"` | 使用/model skill切换模型后提问 | WorkBuddy支持多模型，可通过/model skill切换 |
| `codex --temperature 0.7 "生成创意"` | 请求时指定"使用创造性思维" | 在提示词中指定需要的创造性程度 |

### 代码生成
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "写一个Python函数处理JSON" > func.py` | 1. 请求"写一个Python函数处理JSON"<br>2. 使用Write工具写入func.py | 生成代码后可直接写入文件 |
| `codex "创建React组件" \| tee Component.js` | 1. 请求"创建React组件"<br>2. 复制代码<br>3. Write工具创建Component.js | 支持多步骤操作 |
| `codex "改进这段代码" < buggy.py` | 1. Read工具读取buggy.py<br>2. 提供代码并请求改进<br>3. Edit工具更新文件 | 可直接读取和编辑现有文件 |

## 项目操作命令

### Git操作
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "写一个提交信息"` | 使用/commit技能 | /commit技能自动生成符合规范的提交信息 |
| `codex "分析git差异"` | 1. `Bash(command="git diff")`<br>2. 提供差异并请求分析 | 可结合命令输出和AI分析 |
| `codex "创建分支名称"` | 请求"为功能X建议一个git分支名称" | 可集成到工作流中 |

### 构建与测试
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "解释构建错误"` | 1. `Bash(command="npm run build 2>&1")`<br>2. 提供错误输出并请求解释 | 捕获命令输出并分析 |
| `codex "生成测试用例"` | 请求"为[函数]生成测试用例" | 可生成多种测试框架代码 |
| `codex "优化Dockerfile"` | 提供Dockerfile内容并请求优化 | 可直接编辑Dockerfile |

## 系统与工具命令

### 文件操作
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "重命名这个文件"` | 使用Bash工具或直接请求建议 | 可执行实际重命名操作 |
| `codex "查找重复文件"` | 创建查找脚本或使用现有工具 | WorkBuddy可编写和执行查找脚本 |
| `codex "整理目录结构"` | 请求整理方案后执行 | 分步：分析→建议→执行 |

### 进程管理
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "哪个进程占用端口？"` | `Bash(command="netstat -ano \| findstr :3000")` | 直接执行命令获取信息 |
| `codex "安全停止进程"` | 1. 识别进程<br>2. 安全停止建议<br>3. 执行停止 | 安全检查和建议 |
| `codex "监控系统资源"` | `Bash(command="top -b -n 1 \| head -20", run_in_background=true)` | 后台监控，定期检查 |

## 工作流命令

### 开发工作流
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "设置新项目"` | 创建"项目设置"Skill | 封装为可重用技能 |
| `codex "部署到生产"` | 创建部署Automation | 自动化重复部署任务 |
| `codex "代码审查"` | 使用代码审查代理 | 可启动专门审查代理 |

### 文档工作流
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| `codex "写README"` | 使用docx/pptx技能 | 直接生成格式化文档 |
| `codex "更新API文档"` | 集成Swagger/Apidoc生成 | 自动化文档更新 |
| `codex "创建演示文稿"` | 使用pptx技能 | 生成完整PPT文件 |

## 高级模式

### 管道和重定向
| Codex CLI模式 | WorkBuddy模式 | 说明 |
|---------------|---------------|------|
| `cat file.txt \| codex "总结"` | 1. `Read(file_path="file.txt")`<br>2. 提供内容并请求总结 | 直接读取文件内容 |
| `codex "生成配置" > config.yaml` | 1. 请求生成配置<br>2. `Write(file_path="config.yaml")` | 一步生成并写入 |
| `codex "命令建议" \| sh` | **不推荐** | WorkBuddy提供安全执行环境 |

### 交互式会话
| Codex CLI | WorkBuddy | 说明 |
|-----------|-----------|------|
| 多次`codex`调用保持上下文 | 单次对话保持完整上下文 | WorkBuddy上下文更持久 |
| `codex`历史记录有限 | 完整对话历史可搜索 | 更好的知识追溯 |

## 环境变量和配置

| Codex CLI配置 | WorkBuddy对应 | 说明 |
|---------------|---------------|------|
| `CODEX_API_KEY` | 模型提供商标记 | WorkBuddy支持多提供商 |
| `CODEX_MODEL` | `/model` skill设置 | 可动态切换模型 |
| `CODEX_ORG_ID` | 项目/工作空间配置 | 通过记忆文件管理 |

## 迁移提示

1. **命令提取**：从历史记录中收集常用`codex`命令模式
2. **模式识别**：识别重复工作流，封装为Skill
3. **逐步替换**：从一个命令开始，逐步迁移整个工作流
4. **性能对比**：记录迁移前后的效率变化
5. **反馈循环**：根据使用体验优化技能内容

## 特殊注意事项

1. **敏感信息**：Codex CLI可能暴露API密钥，WorkBuddy有更严格的安全控制
2. **成本管理**：WorkBuddy可能使用不同计费模型，注意用量监控
3. **网络要求**：WorkBuddy可能需要稳定网络连接
4. **工具限制**：某些Codex CLI插件可能无直接对应，需寻找替代方案

---

*此速查表基于常见使用模式，实际迁移时可能需要根据具体工作流调整。*