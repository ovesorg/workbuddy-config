#!/bin/bash
"""
Codex CLI并行执行迁移模板

这个脚本演示了如何将Codex CLI的多终端工作流
迁移到WorkBuddy的并行执行策略。

使用方式:
    bash parallel_executor.sh [模式]

模式:
    simple    - 简单并发执行
    advanced  - 高级依赖管理
    monitor   - 带监控的并行执行
    custom    - 自定义配置执行
"""

set -e  # 遇到错误退出

# 配置参数
CONFIG_FILE="${CONFIG_FILE:-parallel_config.json}"
LOG_DIR="${LOG_DIR:-./logs}"
MAX_PARALLEL="${MAX_PARALLEL:-4}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-300}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 创建日志目录
mkdir -p "$LOG_DIR"

# ============================================================================
# 模式1: 简单并发执行
# 对应Codex CLI的多个独立终端窗口
# ============================================================================
simple_parallel() {
    print_info "模式: 简单并发执行"
    print_info "对应场景: 多个独立的Codex CLI终端窗口"
    
    # 定义要并行执行的任务
    # 这些任务原本可能在不同的终端窗口中运行
    TASKS=(
        "codex '分析项目结构并生成架构图'"
        "codex '检查代码质量问题并生成报告'"
        "codex '生成API文档草案'"
        "codex '运行测试并分析覆盖率'"
    )
    
    # 模拟Codex CLI的多终端执行
    print_info "模拟Codex CLI的4个终端窗口..."
    
    # WorkBuddy迁移方案: 使用并发Bash调用
    cat > workbuddy_migration_simple.md << 'EOF'
## WorkBuddy迁移方案: 简单并发执行

### 原Codex CLI工作流
打开4个终端窗口，分别执行:
1. 终端1: `codex '分析项目结构并生成架构图'`
2. 终端2: `codex '检查代码质量问题并生成报告'`
3. 终端3: `codex '生成API文档草案'`
4. 终端4: `codex '运行测试并分析覆盖率'`

### WorkBuddy实现
```bash
# 在单条消息中并发执行
Bash(command="codex '分析项目结构并生成架构图'", description="分析项目结构")
Bash(command="codex '检查代码质量问题'", description="代码质量检查")
Bash(command="codex '生成API文档草案'", description="生成API文档")
Bash(command="codex '运行测试并分析覆盖率'", description="测试覆盖率分析")

# 或者使用后台任务
Bash(command="长时间分析任务", run_in_background=true, description="后台分析")
# 继续其他工作...
```

### 优势
1. **统一管理**: 所有任务在一个界面中管理
2. **输出聚合**: 所有输出集中保存，便于查阅
3. **错误处理**: 统一错误处理和重试机制
4. **资源控制**: 可控制并发数量，避免系统过载
EOF
    
    print_success "生成迁移指南: workbuddy_migration_simple.md"
    
    # 执行示例（模拟）
    print_info "执行示例任务..."
    for i in "${!TASKS[@]}"; do
        task="${TASKS[$i]}"
        log_file="$LOG_DIR/task_$((i+1)).log"
        
        echo "执行任务$((i+1)): $task" | tee "$log_file"
        echo "开始时间: $(date)" >> "$log_file"
        
        # 模拟执行（实际使用时替换为真实命令）
        echo "模拟执行: $task"
        sleep 1
        
        # 模拟输出
        cat >> "$log_file" << EOF
任务: $task
状态: 完成
输出: 模拟输出内容
耗时: 1秒
EOF
        
        echo "结束时间: $(date)" >> "$log_file"
        echo "" >> "$log_file"
    done
    
    print_success "简单并发执行完成"
}

# ============================================================================
# 模式2: 高级依赖管理
# 对应Codex CLI的有序任务流
# ============================================================================
advanced_dependencies() {
    print_info "模式: 高级依赖管理"
    print_info "对应场景: Codex CLI的有序任务流水线"
    
    # 定义任务及其依赖
    # 这些任务原本可能通过脚本或手动顺序执行
    cat > task_dependencies.json << 'EOF'
{
    "tasks": [
        {
            "id": "analyze",
            "command": "codex '分析项目需求和约束'",
            "description": "项目分析",
            "dependencies": []
        },
        {
            "id": "design",
            "command": "codex '设计系统架构'",
            "description": "架构设计",
            "dependencies": ["analyze"]
        },
        {
            "id": "implement",
            "command": "codex '实现核心模块'",
            "description": "代码实现",
            "dependencies": ["design"]
        },
        {
            "id": "test",
            "command": "codex '编写测试用例'",
            "description": "测试开发",
            "dependencies": ["implement"]
        },
        {
            "id": "document",
            "command": "codex '生成项目文档'",
            "description": "文档编写",
            "dependencies": ["implement"]
        },
        {
            "id": "deploy",
            "command": "codex '生成部署脚本'",
            "description": "部署准备",
            "dependencies": ["test", "document"]
        }
    ]
}
EOF
    
    print_info "任务依赖关系已保存: task_dependencies.json"
    
    # WorkBuddy迁移方案: 使用TaskCreate/TaskUpdate
    cat > workbuddy_migration_advanced.md << 'EOF'
## WorkBuddy迁移方案: 高级依赖管理

### 原Codex CLI工作流
手动或通过脚本顺序执行:
1. `codex '分析项目需求和约束'`
2. `codex '设计系统架构'` (依赖1完成)
3. `codex '实现核心模块'` (依赖2完成)
4. `codex '编写测试用例'` (依赖3完成)
5. `codex '生成项目文档'` (依赖3完成)
6. `codex '生成部署脚本'` (依赖4和5完成)

### WorkBuddy实现
```bash
# 创建任务并设置依赖
TaskCreate(subject="分析项目", description="分析项目需求和约束", task_id="analyze")
TaskCreate(subject="架构设计", description="设计系统架构", task_id="design")
TaskCreate(subject="代码实现", description="实现核心模块", task_id="implement")
TaskCreate(subject="测试开发", description="编写测试用例", task_id="test")
TaskCreate(subject="文档编写", description="生成项目文档", task_id="document")
TaskCreate(subject="部署准备", description="生成部署脚本", task_id="deploy")

# 设置依赖关系
TaskUpdate(task_id="design", addBlockedBy=["analyze"])
TaskUpdate(task_id="implement", addBlockedBy=["design"])
TaskUpdate(task_id="test", addBlockedBy=["implement"])
TaskUpdate(task_id="document", addBlockedBy=["implement"])
TaskUpdate(task_id="deploy", addBlockedBy=["test", "document"])

# 执行任务（系统会自动处理依赖）
TaskUpdate(task_id="analyze", status="in_progress")
# ...执行任务...
TaskUpdate(task_id="analyze", status="completed")
# 依赖任务会自动解除阻塞
```

### 优势
1. **自动调度**: 系统自动处理任务依赖和调度
2. **进度可视化**: 清晰的任务状态和依赖关系图
3. **错误隔离**: 单个任务失败不影响整个流水线
4. **重试机制**: 可配置任务失败重试策略
EOF
    
    print_success "生成迁移指南: workbuddy_migration_advanced.md"
    
    # 执行任务图（模拟）
    print_info "执行任务依赖图..."
    
    # 简单模拟任务执行
    execute_task() {
        local task_id=$1
        local command=$2
        local description=$3
        
        print_info "执行任务: $description ($task_id)"
        echo "命令: $command"
        echo "开始: $(date)"
        
        # 模拟执行
        sleep 2
        
        echo "结束: $(date)"
        echo "状态: 完成"
        echo ""
    }
    
    # 按照依赖顺序执行（简化版本）
    execute_task "analyze" "codex '分析项目需求和约束'" "项目分析"
    execute_task "design" "codex '设计系统架构'" "架构设计"
    execute_task "implement" "codex '实现核心模块'" "代码实现"
    
    # 并行执行test和document
    print_info "并行执行测试和文档任务..."
    execute_task "test" "codex '编写测试用例'" "测试开发" &
    pid1=$!
    execute_task "document" "codex '生成项目文档'" "文档编写" &
    pid2=$!
    
    # 等待并行任务完成
    wait $pid1 $pid2
    
    execute_task "deploy" "codex '生成部署脚本'" "部署准备"
    
    print_success "高级依赖管理执行完成"
}

# ============================================================================
# 模式3: 监控式并行执行
# 对应Codex CLI的长期运行任务+监控
# ============================================================================
monitored_execution() {
    print_info "模式: 监控式并行执行"
    print_info "对应场景: Codex CLI长期任务 + 监控终端"
    
    # 长期运行的任务（原本在后台终端运行）
    LONG_RUNNING_TASKS=(
        "codex '持续监控系统日志并分析模式'"
        "codex '实时代码审查和建议'"
        "codex '性能监控和优化建议'"
    )
    
    # 监控任务
    MONITOR_TASKS=(
        "检查任务状态"
        "收集性能指标"
        "生成监控报告"
    )
    
    # WorkBuddy迁移方案: run_in_background + 定期检查
    cat > workbuddy_migration_monitor.md << 'EOF'
## WorkBuddy迁移方案: 监控式并行执行

### 原Codex CLI工作流
1. 终端1（后台）: `codex '持续监控系统日志并分析模式'`
2. 终端2（后台）: `codex '实时代码审查和建议'`
3. 终端3（后台）: `codex '性能监控和优化建议'`
4. 终端4（监控）: 定期检查上述任务状态

### WorkBuddy实现
```bash
# 启动长期后台任务
log_monitor_task=$(Bash(
    command="codex '持续监控系统日志并分析模式'",
    run_in_background=true,
    description="日志监控"
))

code_review_task=$(Bash(
    command="codex '实时代码审查和建议'",
    run_in_background=true,
    description="代码审查"
))

performance_task=$(Bash(
    command="codex '性能监控和优化建议'",
    run_in_background=true,
    description="性能监控"
))

# 监控循环
while true; do
    # 检查任务状态
    echo "=== 任务状态检查 $(date) ==="
    
    # 检查日志监控任务
    if TaskOutput(task_id="$log_monitor_task" 2>/dev/null); then
        echo "日志监控: 运行中"
    else
        echo "日志监控: 已停止"
    fi
    
    # 检查代码审查任务
    if TaskOutput(task_id="$code_review_task" 2>/dev/null); then
        echo "代码审查: 运行中"
    else
        echo "代码审查: 已停止"
    fi
    
    # 检查性能监控任务
    if TaskOutput(task_id="$performance_task" 2>/dev/null); then
        echo "性能监控: 运行中"
    else
        echo "性能监控: 已停止"
    fi
    
    # 生成监控报告
    Bash(command="生成监控报告脚本")
    
    # 等待下一轮检查
    sleep 60
done
```

### 优势
1. **状态集中**: 所有后台任务状态集中监控
2. **自动恢复**: 可配置任务失败自动重启
3. **历史记录**: 完整的监控历史记录
4. **告警集成**: 可集成告警机制
EOF
    
    print_success "生成迁移指南: workbuddy_migration_monitor.md"
    
    # 模拟监控执行
    print_info "启动长期运行任务..."
    
    for i in "${!LONG_RUNNING_TASKS[@]}"; do
        task="${LONG_RUNNING_TASKS[$i]}"
        log_file="$LOG_DIR/long_task_$((i+1)).log"
        
        echo "启动长期任务$((i+1)): $task" | tee "$log_file"
        echo "任务ID: simulated_$((i+1))" >> "$log_file"
        echo "启动时间: $(date)" >> "$log_file"
    done
    
    print_info "开始监控循环..."
    
    for monitor_round in {1..3}; do
        echo ""
        print_info "监控轮次 $monitor_round"
        echo "时间: $(date)"
        
        # 模拟检查任务状态
        for i in {1..3}; do
            status=$((RANDOM % 3))
            case $status in
                0) state="运行中";;
                1) state="空闲";;
                2) state="忙碌";;
            esac
            
            echo "  任务$i: $state | 运行时间: $((monitor_round * 20))秒"
            
            # 记录到日志
            echo "监控点 $monitor_round - 任务$i: $state" >> "$LOG_DIR/long_task_$i.log"
        done
        
        # 模拟生成监控报告
        report_file="$LOG_DIR/monitor_report_${monitor_round}.md"
        cat > "$report_file" << EOF
# 监控报告 - 轮次 $monitor_round
生成时间: $(date)

## 任务状态
1. 任务1: 运行中
2. 任务2: 空闲
3. 任务3: 忙碌

## 系统指标
- CPU使用率: $((30 + monitor_round * 5))%
- 内存使用: $((200 + monitor_round * 10))MB
- 磁盘空间: 剩余 $((50 - monitor_round))GB

## 建议
- 任务3负载较高，考虑优化
- 系统资源使用正常
EOF
        
        echo "生成监控报告: $report_file"
        
        if [ $monitor_round -lt 3 ]; then
            echo "等待下一轮监控..."
            sleep 2
        fi
    done
    
    print_success "监控式并行执行完成"
}

# ============================================================================
# 模式4: 自定义配置执行
# 根据配置文件执行复杂工作流
# ============================================================================
custom_execution() {
    print_info "模式: 自定义配置执行"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_warning "配置文件 $CONFIG_FILE 不存在，创建示例配置"
        
        cat > "$CONFIG_FILE" << 'EOF'
{
    "name": "Codex CLI迁移示例配置",
    "description": "演示如何配置复杂并行工作流",
    "max_parallel": 3,
    "timeout_seconds": 600,
    "tasks": [
        {
            "name": "项目分析",
            "command": "codex '分析项目结构和依赖'",
            "category": "analysis",
            "timeout": 120,
            "retries": 2
        },
        {
            "name": "代码生成",
            "command": "codex '生成核心业务逻辑代码'",
            "category": "development",
            "dependencies": ["项目分析"],
            "parallel_group": "dev_tasks"
        },
        {
            "name": "测试生成",
            "command": "codex '生成单元测试和集成测试'",
            "category": "testing",
            "dependencies": ["代码生成"],
            "parallel_group": "dev_tasks"
        },
        {
            "name": "文档生成",
            "command": "codex '生成API文档和用户指南'",
            "category": "documentation",
            "dependencies": ["代码生成"],
            "parallel_group": "doc_tasks"
        },
        {
            "name": "部署配置",
            "command": "codex '生成部署配置和脚本'",
            "category": "deployment",
            "dependencies": ["测试生成", "文档生成"],
            "critical": true
        }
    ],
    "monitoring": {
        "enabled": true,
        "interval_seconds": 30,
        "alert_on_failure": true
    }
}
EOF
        print_success "创建示例配置: $CONFIG_FILE"
    fi
    
    print_info "加载配置: $CONFIG_FILE"
    
    # WorkBuddy迁移方案: 配置驱动执行
    cat > workbuddy_migration_custom.md << 'EOF'
## WorkBuddy迁移方案: 配置驱动执行

### 原Codex CLI工作流
通过复杂的脚本配置文件管理任务:
- 定义任务、依赖、超时设置
- 手动或通过脚本调度执行
- 监控任务状态和结果

### WorkBuddy实现
```bash
# 读取配置并创建任务
config=$(Read(file_path="parallel_config.json"))

# 解析配置并创建任务
# 伪代码，展示思路:
for task in config.tasks:
    TaskCreate(
        subject=task.name,
        description=task.command,
        task_id=task.name
    )
    
    if task.dependencies:
        TaskUpdate(
            task_id=task.name,
            addBlockedBy=task.dependencies
        )

# 根据配置执行
if config.monitoring.enabled:
    # 启动监控
    while True:
        check_tasks_status()
        generate_monitoring_report()
        sleep(config.monitoring.interval_seconds)

# 自动化执行
execute_with_constraints(
    max_parallel=config.max_parallel,
    timeout=config.timeout_seconds
)
```

### 优势
1. **配置即代码**: 工作流定义可版本控制
2. **灵活调度**: 支持复杂依赖和约束
3. **可重用模板**: 配置模板可跨项目重用
4. **自动化测试**: 工作流配置可自动化测试
EOF
    
    print_success "生成迁移指南: workbuddy_migration_custom.md"
    
    # 演示配置加载和执行
    print_info "解析配置并执行..."
    
    # 模拟配置解析
    echo "配置内容概要:"
    echo "----------------------------------------"
    grep -E '"name"|"description"|"command"' "$CONFIG_FILE" | head -10 | sed 's/^/  /'
    echo "----------------------------------------"
    
    # 模拟任务执行
    print_info "根据配置执行任务..."
    
    task_count=$(grep -c '"name"' "$CONFIG_FILE")
    print_info "发现 $task_count 个任务"
    
    # 模拟执行流程
    cat > execution_plan.md << 'EOF'
# 执行计划

## 阶段1: 独立任务
1. 项目分析 - 无依赖，立即执行

## 阶段2: 并行开发任务
2. 代码生成 - 依赖: 项目分析
3. 测试生成 - 依赖: 代码生成 (与文档生成并行)
4. 文档生成 - 依赖: 代码生成 (与测试生成并行)

## 阶段3: 最终任务
5. 部署配置 - 依赖: 测试生成, 文档生成

## 约束
- 最大并行数: 3
- 总超时: 600秒
- 监控间隔: 30秒
EOF
    
    print_success "生成执行计划: execution_plan.md"
    
    # 模拟执行
    execute_phase() {
        local phase=$1
        shift
        local tasks=("$@")
        
        print_info "执行阶段: $phase"
        for task in "${tasks[@]}"; do
            echo "  执行: $task"
            sleep 1
        done
    }
    
    execute_phase "阶段1" "项目分析"
    execute_phase "阶段2" "代码生成"
    execute_phase "阶段2-并行" "测试生成" "文档生成"
    execute_phase "阶段3" "部署配置"
    
    print_success "自定义配置执行完成"
}

# ============================================================================
# 主函数
# ============================================================================
main() {
    print_info "Codex CLI并行执行迁移演示"
    print_info "当前目录: $(pwd)"
    print_info "日志目录: $LOG_DIR"
    
    MODE="${1:-simple}"
    
    case "$MODE" in
        simple)
            simple_parallel
            ;;
        advanced)
            advanced_dependencies
            ;;
        monitor)
            monitored_execution
            ;;
        custom)
            custom_execution
            ;;
        all)
            simple_parallel
            echo ""
            advanced_dependencies
            echo ""
            monitored_execution
            echo ""
            custom_execution
            ;;
        help|--help|-h)
            echo "使用方式: $0 [模式]"
            echo "模式: simple, advanced, monitor, custom, all"
            echo "环境变量:"
            echo "  LOG_DIR - 日志目录 (默认: ./logs)"
            echo "  MAX_PARALLEL - 最大并行数 (默认: 4)"
            echo "  TIMEOUT_SECONDS - 超时时间 (默认: 300)"
            exit 0
            ;;
        *)
            print_error "未知模式: $MODE"
            echo "使用: $0 help 查看帮助"
            exit 1
            ;;
    esac
    
    print_success "所有任务完成!"
    print_info "生成的迁移指南:"
    ls -la workbuddy_migration_*.md 2>/dev/null || echo "无迁移指南文件"
    print_info "日志文件:"
    ls -la "$LOG_DIR/"*.log 2>/dev/null | head -5 || echo "无日志文件"
    
    # 生成总结报告
    cat > migration_summary.md << EOF
# Codex CLI并行执行迁移总结

## 执行模式: $MODE
执行时间: $(date)

## 生成的文件
$(ls -1 workbuddy_migration_*.md 2>/dev/null | sed 's/^/- /')

## 关键收获
1. **并发管理**: WorkBuddy提供多种并行执行策略
2. **依赖处理**: 内置任务依赖管理，替代手动协调
3. **监控集成**: 统一监控界面，替代多个监控终端
4. **配置驱动**: 可配置的工作流，提高可重用性

## 下一步
1. 根据生成的迁移指南调整实际工作流
2. 测试WorkBuddy并行执行性能
3. 优化配置，提高效率
4. 分享经验，建立团队最佳实践
EOF
    
    print_success "生成总结报告: migration_summary.md"
}

# 执行主函数
main "$@"