# Codex CLI迁移故障排除指南

## 常见问题分类

### 1. 命令执行问题

#### 症状：Codex CLI命令在WorkBuddy中失败

**可能原因和解决方案：**

| 症状 | 可能原因 | 诊断步骤 | 解决方案 |
|------|----------|----------|----------|
| `codex: command not found` | PATH配置不正确 | `Bash(command="which codex")` `Bash(command="echo $PATH")` | 1. 检查Codex CLI安装路径<br>2. 更新PATH环境变量<br>3. 使用绝对路径：`/c/Users/Huashan_Wang/AppData/Roaming/npm/codex` |
| 命令超时 | 网络问题或命令长时间运行 | 检查命令是否需要交互输入 | 1. 增加timeout参数<br>2. 使用`run_in_background: true`<br>3. 分解复杂命令 |
| 权限错误 | 沙箱限制或文件权限 | `Bash(command="ls -la 目标文件")` | 1. 检查文件所有权和权限<br>2. 使用`dangerouslyDisableSandbox: true`（谨慎）<br>3. 修改文件权限 |
| 命令输出乱码 | 编码问题或特殊字符 | `Bash(command="file -i 输出文件")` | 1. 指定编码：`LANG=en_US.UTF-8`<br>2. 使用`iconv`转换编码<br>3. 过滤特殊字符 |

**诊断脚本：**
```bash
# 综合诊断命令
Bash(command="codex --version 2>&1")
Bash(command="which codex")
Bash(command="ls -la $(which codex)")
Bash(command="file $(which codex)")
Bash(command="npm list -g codex 2>/dev/null || echo '未通过npm安装'")
```

#### 症状：特定命令行为不一致

**解决方案：**
1. **命令参数差异**：Codex CLI和直接Bash调用可能有不同参数
   ```bash
   # Codex CLI风格
   codex --model gpt-4 "提示词"
   
   # WorkBuddy中等效操作
   # 先切换模型（如果支持）
   Skill(skill="model", args="gpt-4")
   # 然后提问
   ```
   
2. **环境变量差异**：检查`.bashrc`、`.profile`中的特定配置
   ```bash
   # 对比环境变量
   Bash(command="env | grep -i codex")
   # 与终端中的env对比
   ```

3. **工作目录差异**：确保工作目录一致
   ```bash
   Bash(command="pwd")
   Bash(command="cd /正确/路径 && codex '命令'")
   ```

### 2. 并行执行问题

#### 症状：后台任务丢失或无法监控

**诊断和修复：**

1. **任务ID记录**：为每个后台任务记录标识符
   ```bash
   # 启动任务时记录ID
   task1=$(Bash(command="长时间任务", run_in_background=true))
   echo "任务ID: $task1"
   
   # 稍后检查
   TaskOutput(task_id="$task1")
   ```

2. **进程泄漏检测**：
   ```bash
   # 查找僵尸进程
   Bash(command="ps aux | grep -i workbuddy")
   Bash(command="ps aux | grep -i '长时间任务'")
   
   # 清理残留
   Bash(command="pkill -f '长时间任务' 2>/dev/null || true")
   ```

3. **资源限制**：检查系统资源限制
   ```bash
   Bash(command="ulimit -a")
   Bash(command="sysctl kernel.pid_max")
   ```

#### 症状：并发冲突或竞态条件

**解决方案：**
1. **文件锁机制**：
   ```bash
   # 使用flock实现互斥
   Bash(command="flock -x lockfile.lock -c '关键操作'")
   ```

2. **顺序化控制**：
   ```bash
   # 使用Task依赖确保顺序
   TaskCreate(subject="任务A", task_id="task_a")
   TaskCreate(subject="任务B", task_id="task_b")
   TaskUpdate(task_id="task_b", addBlockedBy=["task_a"])
   ```

3. **重试机制**：
   ```bash
   for attempt in {1..3}; do
       if Bash(command="可能冲突的命令"); then
           break
       else
           sleep $((attempt * 2))
       fi
   done
   ```

### 3. 上下文和记忆问题

#### 症状：工作记忆丢失或不一致

**诊断步骤：**
1. **检查记忆文件结构**：
   ```bash
   Bash(command="ls -la C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/")
   Bash(command="cat C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/$(date +%Y-%m-%d).md 2>/dev/null || echo '无今日记忆'")
   ```

2. **验证记忆写入**：
   ```bash
   # 测试记忆写入
   test_note="测试记忆写入 $(date)"
   # [通过replace_in_file写入记忆]
   # 然后检查
   Bash(command="grep -n '测试记忆写入' C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/$(date +%Y-%m-%d).md")
   ```

**常见修复：**
1. **文件权限问题**：
   ```bash
   Bash(command="chmod 755 C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/")
   ```

2. **磁盘空间不足**：
   ```bash
   Bash(command="df -h C:/")
   ```

3. **文件损坏**：
   ```bash
   # 备份后重建
   Bash(command="cp C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/MEMORY.md C:/Users/Huashan_Wang/WorkBuddy/2026-05-14-task-1/.workbuddy/memory/MEMORY.md.backup")
   # [重建文件]
   ```

#### 症状：技能加载失败

**解决方案：**
1. **技能路径验证**：
   ```bash
   Bash(command="ls -la ~/.workbuddy/skills/codex-cli-migration/SKILL.md")
   Bash(command="head -5 ~/.workbuddy/skills/codex-cli-migration/SKILL.md")
   ```

2. **技能格式检查**：
   ```bash
   # 检查YAML frontmatter
   Bash(command="sed -n '1,10p' ~/.workbuddy/skills/codex-cli-migration/SKILL.md")
   ```

3. **重新安装技能**：
   ```bash
   # 备份现有技能
   Bash(command="cp -r ~/.workbuddy/skills/codex-cli-migration ~/.workbuddy/skills/codex-cli-migration.bak")
   # 重新运行初始化脚本
   ```

### 4. 性能问题

#### 症状：响应缓慢或超时

**性能诊断：**
```bash
# 系统资源检查
Bash(command="top -b -n 1 | head -20")
Bash(command="free -h")
Bash(command="iostat -x 1 3")

# 网络检查
Bash(command="ping -c 3 api.openai.com 2>/dev/null || echo '网络不通'")
Bash(command="curl -w '%{time_total}\n' -o /dev/null -s https://api.openai.com")

# WorkBuddy特定检查
Bash(command="ps aux | grep -i workbuddy | grep -v grep")
```

**优化策略：**
1. **减少上下文大小**：
   - 使用references/目录存储大文档
   - 定期清理不需要的上下文
   - 使用摘要而非完整内容

2. **优化命令执行**：
   ```bash
   # 使用更快的替代命令
   # 慢：find . -name "*.js" | xargs grep "pattern"
   # 快：rg "pattern" -g "*.js"
   ```

3. **批量操作**：
   ```bash
   # 避免多次小操作
   # 差：多次Write小文件
   # 好：一次Write包含所有内容
   ```

### 5. 集成问题

#### 症状：与现有工具链不兼容

**诊断矩阵：**

| 工具 | 兼容性问题 | 解决方案 |
|------|------------|----------|
| **Git** | 钩子执行失败 | 1. 检查钩子权限<br>2. 使用`/commit`技能处理提交<br>3. 手动执行：`Bash(command="git commit -m '消息'")` |
| **Docker** | 容器内命令失败 | 1. 确保Docker守护进程运行<br>2. 使用`docker exec`而非容器内命令<br>3. 检查卷挂载权限 |
| **npm/yarn** | 包安装失败 | 1. 清除缓存：`npm cache clean --force`<br>2. 使用`--verbose`标志诊断<br>3. 检查网络代理设置 |
| **VS Code** | 扩展不工作 | 1. 通过Bash调用VS Code命令<br>2. 使用VSCode的远程开发功能<br>3. 创建专门集成技能 |

**集成测试脚本：**
```bash
#!/bin/bash
# 工具链兼容性测试
echo "=== 工具链兼容性测试 ==="

# Git测试
echo "1. Git测试..."
Bash(command="git --version")
Bash(command="git status 2>&1")

# Node测试
echo "2. Node测试..."
Bash(command="node --version")
Bash(command="npm --version")

# Docker测试
echo "3. Docker测试..."
Bash(command="docker --version 2>/dev/null || echo 'Docker未安装'")
Bash(command="docker ps 2>&1 | head -5")

# 关键路径测试
echo "4. 路径测试..."
Bash(command="which codex")
Bash(command="which python")
```

## 系统级问题

### 操作系统特定问题

#### Windows特有问题：
```bash
# 路径转换问题
# 错误：C:\Users\... 在Git Bash中无效
# 正确：/c/Users/... 或 "C:\\Users\\..."

# 解决方案：
Bash(command="cd '/c/Users/Huashan_Wang' && pwd")
# 或使用PowerShell工具处理Windows路径
```

#### 权限提升问题：
```bash
# 需要管理员权限的命令
# 尝试方法：
Bash(command="sudo 命令" 2>&1)
# 如果失败，可能需要用户交互授权
# 替代方案：分解任务，避免需要提权的操作
```

### 网络和安全问题

#### 防火墙/代理问题：
```bash
# 诊断网络连接
Bash(command="curl -v https://api.openai.com 2>&1 | grep -i 'HTTP\|error'")
Bash(command="nc -zv api.openai.com 443")

# 代理配置检查
Bash(command="echo $http_proxy $https_proxy")
Bash(command="cat ~/.curlrc 2>/dev/null || echo '无curl配置'")
```

#### 证书问题：
```bash
# SSL证书验证失败
Bash(command="curl -k https://api.openai.com")  # 不安全，仅用于测试
# 永久解决方案：更新CA证书
```

## 调试技术

### 1. 详细日志记录

```bash
# 启用详细日志
debug_log="debug_$(date +%Y%m%d_%H%M%S).log"

# 记录所有命令和输出
exec 2>&1 | tee "$debug_log"

# 在WorkBuddy中可通过组合实现
Bash(command="命令1 2>&1 | tee -a command1.log")
Bash(command="命令2 2>&1 | tee -a command2.log")
```

### 2. 分步执行

```bash
# 复杂命令分解
echo "步骤1: 准备环境"
Bash(command="命令1")

echo "步骤2: 验证环境"
Bash(command="验证命令")

echo "步骤3: 执行主操作"
Bash(command="主命令")

echo "步骤4: 清理"
Bash(command="清理命令")
```

### 3. 最小化复现

```bash
# 创建最小测试用例
test_script="最小测试.sh"
cat > "$test_script" << 'EOF'
#!/bin/bash
echo "最小化测试开始"
# 仅包含问题命令
有问题的命令
echo "退出码: $?"
EOF

Bash(command="bash $test_script")
```

## 紧急恢复步骤

### 当迁移完全失败时：

1. **立即回滚**：
   ```bash
   # 恢复原始工作流
   echo "恢复Codex CLI工作流..."
   # 使用原有的终端和脚本
   ```

2. **收集诊断信息**：
   ```bash
   # 收集所有相关信息
   diagnostic_package="迁移失败诊断_$(date +%Y%m%d_%H%M%S).tar.gz"
   tar -czf "$diagnostic_package" \
     ~/.workbuddy/skills/codex-cli-migration/ \
     ~/.workbuddy/memory/ \
     ./debug_*.log \
     /tmp/workbuddy_* 2>/dev/null
   ```

3. **寻求帮助**：
   - 提供诊断包
   - 描述具体失败场景
   - 提供错误消息和日志

### 渐进恢复策略：

1. **混合模式运行**：部分工作流用WorkBuddy，部分用Codex CLI
2. **影子运行**：WorkBuddy执行但不实际修改，与Codex CLI结果对比
3. **特性开关**：通过配置选择执行引擎

## 预防措施

### 1. 定期健康检查

```bash
# 每天运行的检查脚本
health_check() {
    echo "=== WorkBuddy健康检查 $(date) ==="
    
    # 基础功能检查
    check_command "Bash(command='echo 测试')" "基础命令执行"
    check_command "Read(file_path='技能路径/SKILL.md')" "文件读取"
    
    # 集成检查
    check_command "Bash(command='git --version')" "Git集成"
    check_command "Bash(command='codex --version 2>&1')" "Codex CLI集成"
    
    # 性能检查
    check_command "Bash(command='time curl -s https://api.openai.com >/dev/null')" "网络响应"
    
    echo "健康检查完成"
}

check_command() {
    cmd=$1
    desc=$2
    echo -n "检查 $desc... "
    if eval "$cmd" >/dev/null 2>&1; then
        echo "✓"
    else
        echo "✗"
    fi
}
```

### 2. 备份策略

```bash
# 定期备份关键配置
backup_dir="~/.workbuddy/backups/$(date +%Y-%m-%d)"
mkdir -p "$backup_dir"

# 备份技能
cp -r ~/.workbuddy/skills/codex-cli-migration "$backup_dir/"

# 备份记忆
cp -r ~/.workbuddy/memory "$backup_dir/" 2>/dev/null

# 备份自动化配置
# [通过automation_update导出配置]
```

### 3. 监控告警

```bash
# 关键指标监控
monitor_metrics() {
    # 错误率监控
    error_count=$(grep -c "ERROR\|FAILED" 日志文件)
    if [ "$error_count" -gt 10 ]; then
        echo "警告: 高错误率 detected"
    fi
    
    # 响应时间监控
    response_time=$(测量命令)
    if [ "$response_time" -gt 5000 ]; then
        echo "警告: 响应时间过长"
    fi
    
    # 资源使用监控
    memory_usage=$(检查内存使用)
    if [ "$memory_usage" -gt 90 ]; then
        echo "警告: 高内存使用"
    fi
}
```

## 支持渠道

### 获取帮助的途径：

1. **文档资源**：
   - 此故障排除指南
   - WorkBuddy官方文档
   - Codex CLI迁移技能中的references/

2. **社区支持**：
   - WorkBuddy用户社区
   - GitHub Issues
   - 相关论坛和讨论组

3. **专业支持**：
   - 官方技术支持
   - 咨询服务
   - 定制开发支持

### 提供问题报告时包含的信息：

```markdown
## 问题报告模板

### 问题描述
[清晰描述问题]

### 重现步骤
1. 
2. 
3. 

### 预期行为
[应该发生什么]

### 实际行为
[实际发生了什么]

### 环境信息
- 操作系统: 
- WorkBuddy版本: 
- Codex CLI版本: 
- 相关配置: 

### 日志输出
[相关日志和错误消息]

### 已尝试的解决方案
[列出已尝试的修复方法]
```

---

*记住：大多数迁移问题都是暂时的，通过系统化诊断和逐步解决，通常可以找到解决方案。保持耐心，有条理地解决问题。*