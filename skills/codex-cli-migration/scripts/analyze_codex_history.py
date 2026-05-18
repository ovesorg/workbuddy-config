#!/usr/bin/env python3
"""
Codex CLI使用历史分析脚本

分析用户的Codex CLI命令历史，识别常用模式，
生成迁移到WorkBuddy的建议报告。

使用方法:
    python analyze_codex_history.py [history_file] [--output report.md]

如果没有提供history_file，脚本会尝试从常见位置查找：
1. ~/.codex/history.log
2. 终端历史中的codex命令
3. 用户提供的自定义日志文件
"""

import os
import sys
import json
import re
import argparse
from datetime import datetime
from collections import Counter
from pathlib import Path

class CodexHistoryAnalyzer:
    def __init__(self):
        self.command_patterns = {
            'code_generation': [
                r'codex.*(写|生成|创建|实现).*(函数|类|代码|程序|脚本)',
                r'codex.*(function|class|code|script|program)',
                r'codex.*(write|generate|create|implement)'
            ],
            'code_explanation': [
                r'codex.*(解释|说明|分析|理解).*(代码|函数|类|错误)',
                r'codex.*(explain|analyze|understand|interpret)',
                r'codex.*(这段|这个|那个).*(代码|程序)'
            ],
            'debugging': [
                r'codex.*(错误|bug|问题|故障|调试)',
                r'codex.*(error|bug|issue|debug|fix)',
                r'codex.*(为什么|如何修复|怎么解决)'
            ],
            'documentation': [
                r'codex.*(文档|注释|README|说明|手册)',
                r'codex.*(documentation|comment|readme|manual|doc)'
            ],
            'refactoring': [
                r'codex.*(重构|优化|改进|清理|整理)',
                r'codex.*(refactor|optimize|improve|clean|reorganize)'
            ],
            'testing': [
                r'codex.*(测试|单元测试|集成测试|测试用例)',
                r'codex.*(test|unit test|integration|test case)'
            ],
            'configuration': [
                r'codex.*(配置|设置|安装|部署|环境)',
                r'codex.*(config|setup|install|deploy|environment)'
            ]
        }
        
        self.workbuddy_mapping = {
            'code_generation': {
                'description': '代码生成',
                'workbuddy_approach': '直接向WorkBuddy请求代码，然后使用Write工具保存',
                'example': 'codex "写一个Python函数处理CSV" → 请求"创建一个Python函数处理CSV文件"'
            },
            'code_explanation': {
                'description': '代码解释',
                'workbuddy_approach': '提供代码片段并请求解释，可要求图表或逐步说明',
                'example': 'codex "解释这段React代码" → 粘贴代码并问"请解释这段React代码的工作原理"'
            },
            'debugging': {
                'description': '错误调试',
                'workbuddy_approach': '提供错误信息并请求分析，可要求修复方案',
                'example': 'codex "这个TypeScript错误什么意思" → 提供错误信息并问"分析这个TypeScript错误的原因和解决方案"'
            },
            'documentation': {
                'description': '文档生成',
                'workbuddy_approach': '使用docx/pptx技能或直接生成Markdown',
                'example': 'codex "为这个API写文档" → 使用docx技能生成完整API文档'
            },
            'refactoring': {
                'description': '代码重构',
                'workbuddy_approach': '提供代码并请求重构建议，使用Edit工具实施更改',
                'example': 'codex "重构这个函数" → 提供代码并请求"重构这个函数以提高可读性和性能"'
            },
            'testing': {
                'description': '测试生成',
                'workbuddy_approach': '请求生成测试用例，可指定测试框架',
                'example': 'codex "为这个组件写测试" → 请求"为React组件生成Jest测试用例"'
            },
            'configuration': {
                'description': '配置管理',
                'workbuddy_approach': '请求配置文件生成或分析，使用Write工具创建文件',
                'example': 'codex "创建docker-compose.yml" → 请求"生成一个Docker Compose配置用于Node.js应用"'
            }
        }
        
    def find_history_files(self):
        """查找可能的Codex历史文件"""
        potential_files = []
        
        # 用户主目录下的.codex历史
        home = Path.home()
        codex_history = home / '.codex' / 'history.log'
        if codex_history.exists():
            potential_files.append(codex_history)
        
        # 常见终端历史文件
        terminal_histories = [
            home / '.bash_history',
            home / '.zsh_history',
            home / '.history',
        ]
        
        for hist in terminal_histories:
            if hist.exists():
                potential_files.append(hist)
        
        return potential_files
    
    def extract_codex_commands(self, file_path):
        """从文件中提取codex命令"""
        commands = []
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                
                # 查找codex命令
                # 简单匹配：以codex开头的行
                lines = content.split('\n')
                for line in lines:
                    line = line.strip()
                    if line.startswith('codex'):
                        commands.append(line)
                    # 也可能在更复杂的命令中
                    elif 'codex ' in line:
                        # 提取codex命令部分
                        match = re.search(r'(codex\s+.*?)(?=\s*[;&|]|$)', line)
                        if match:
                            commands.append(match.group(1))
        
        except Exception as e:
            print(f"读取文件 {file_path} 时出错: {e}")
            
        return commands
    
    def categorize_command(self, command):
        """将命令分类到预定义模式"""
        command_lower = command.lower()
        
        for category, patterns in self.command_patterns.items():
            for pattern in patterns:
                if re.search(pattern, command_lower, re.IGNORECASE):
                    return category
        
        return 'other'
    
    def analyze_commands(self, commands):
        """分析命令集合"""
        if not commands:
            return {
                'total_commands': 0,
                'categories': {},
                'common_patterns': [],
                'migration_recommendations': []
            }
        
        # 分类统计
        categories = Counter()
        categorized_commands = {cat: [] for cat in self.command_patterns.keys()}
        categorized_commands['other'] = []
        
        for cmd in commands:
            category = self.categorize_command(cmd)
            categories[category] += 1
            categorized_commands[category].append(cmd)
        
        # 识别常见模式
        common_patterns = []
        for category, count in categories.most_common(5):
            if count > 0:
                # 检查该类别中的具体命令
                sample_commands = categorized_commands[category][:3]
                common_patterns.append({
                    'category': category,
                    'count': count,
                    'percentage': (count / len(commands)) * 100,
                    'sample_commands': sample_commands
                })
        
        # 生成迁移建议
        migration_recommendations = []
        for pattern in common_patterns:
            category = pattern['category']
            if category in self.workbuddy_mapping:
                mapping = self.workbuddy_mapping[category]
                
                recommendation = {
                    'pattern': mapping['description'],
                    'frequency': f"{pattern['count']}次 ({pattern['percentage']:.1f}%)",
                    'workbuddy_approach': mapping['workbuddy_approach'],
                    'example_migration': mapping['example'],
                    'priority': '高' if pattern['percentage'] > 20 else '中' if pattern['percentage'] > 5 else '低'
                }
                
                migration_recommendations.append(recommendation)
        
        return {
            'total_commands': len(commands),
            'categories': dict(categories),
            'common_patterns': common_patterns,
            'migration_recommendations': migration_recommendations,
            'categorized_commands': categorized_commands
        }
    
    def generate_report(self, analysis, output_file=None):
        """生成迁移分析报告"""
        report = []
        
        # 报告头
        report.append(f"# Codex CLI迁移分析报告")
        report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"分析命令总数: {analysis['total_commands']}")
        report.append("")
        
        if analysis['total_commands'] == 0:
            report.append("## 未找到Codex命令")
            report.append("未在历史文件中找到codex命令，可能是：")
            report.append("1. Codex CLI未安装或未使用")
            report.append("2. 历史文件位置不正确")
            report.append("3. 历史记录被清除")
            report.append("")
            report.append("建议手动记录常用codex命令模式。")
        else:
            # 使用模式概览
            report.append("## 使用模式概览")
            report.append("")
            
            for pattern in analysis['common_patterns']:
                report.append(f"### {self.workbuddy_mapping.get(pattern['category'], {'description': pattern['category']})['description']}")
                report.append(f"- 使用次数: {pattern['count']} ({pattern['percentage']:.1f}%)")
                report.append(f"- 示例命令:")
                for cmd in pattern['sample_commands']:
                    report.append(f"  - `{cmd}`")
                report.append("")
            
            # 迁移建议
            report.append("## 迁移到WorkBuddy的建议")
            report.append("")
            
            if analysis['migration_recommendations']:
                for rec in analysis['migration_recommendations']:
                    report.append(f"### {rec['pattern']} (优先级: {rec['priority']})")
                    report.append(f"- **使用频率**: {rec['frequency']}")
                    report.append(f"- **WorkBuddy方案**: {rec['workbuddy_approach']}")
                    report.append(f"- **迁移示例**: {rec['example_migration']}")
                    report.append("")
            else:
                report.append("未识别出可迁移的常用模式。")
            
            # 详细命令分类
            report.append("## 详细命令分类")
            report.append("")
            
            for category, commands in analysis['categorized_commands'].items():
                if commands:
                    category_name = self.workbuddy_mapping.get(category, {'description': category})['description']
                    report.append(f"### {category_name}")
                    report.append(f"命令数量: {len(commands)}")
                    report.append("")
                    
                    # 显示前10个命令
                    for i, cmd in enumerate(commands[:10], 1):
                        report.append(f"{i}. `{cmd}`")
                    
                    if len(commands) > 10:
                        report.append(f"... 还有 {len(commands) - 10} 个命令")
                    report.append("")
            
            # 行动计划
            report.append("## 迁移行动计划")
            report.append("")
            report.append("### 第一阶段：高频模式迁移")
            report.append("1. 选择使用频率最高的2-3个模式")
            report.append("2. 在WorkBuddy中创建对应的Skill")
            report.append("3. 测试迁移方案，确保功能一致")
            report.append("")
            
            report.append("### 第二阶段：中级频率模式")
            report.append("1. 迁移中等使用频率的模式")
            report.append("2. 优化工作流，利用WorkBuddy优势")
            report.append("3. 创建自动化任务")
            report.append("")
            
            report.append("### 第三阶段：低频和特殊模式")
            report.append("1. 处理剩余使用模式")
            report.append("2. 创建应急回滚方案")
            report.append("3. 全面测试和优化")
            report.append("")
            
            # 最佳实践
            report.append("## 迁移最佳实践")
            report.append("")
            report.append("1. **渐进迁移**：不要一次性迁移所有工作流")
            report.append("2. **并行运行**：初期同时使用Codex CLI和WorkBuddy对比结果")
            report.append("3. **收集反馈**：记录迁移过程中的问题和解决方案")
            report.append("4. **性能监控**：比较迁移前后的效率和准确性")
            report.append("5. **团队协作**：如果是团队环境，确保知识共享")
        
        # 生成报告
        report_text = '\n'.join(report)
        
        if output_file:
            try:
                with open(output_file, 'w', encoding='utf-8') as f:
                    f.write(report_text)
                print(f"报告已保存到: {output_file}")
            except Exception as e:
                print(f"保存报告时出错: {e}")
                # 仍然在控制台输出
                print("\n" + "="*80 + "\n")
                print(report_text)
        else:
            print(report_text)
        
        return report_text
    
    def generate_migration_script(self, analysis, output_script=None):
        """生成自动化迁移脚本的框架"""
        if analysis['total_commands'] == 0:
            return None
        
        script = []
        script.append("#!/bin/bash")
        script.append("# Codex CLI到WorkBuddy迁移辅助脚本")
        script.append("# 自动生成的脚本框架，需要根据实际情况调整")
        script.append("")
        script.append("set -e  # 遇到错误退出")
        script.append("")
        
        # 根据分析结果生成脚本片段
        script.append("echo '=== Codex CLI迁移辅助脚本 ==='")
        script.append("echo ''")
        
        for pattern in analysis['common_patterns']:
            category = pattern['category']
            if category in self.workbuddy_mapping:
                mapping = self.workbuddy_mapping[category]
                
                script.append(f"echo '处理模式: {mapping['description']}'")
                script.append(f"echo '出现次数: {pattern['count']}'")
                script.append("echo ''")
                
                # 为每个模式生成模板函数
                func_name = f"migrate_{category}"
                script.append(f"{func_name}() {{")
                script.append(f"    echo '迁移 {mapping['description']} 模式'")
                script.append(f"    # TODO: 实现 {mapping['description']} 迁移逻辑")
                script.append(f"    # 原Codex命令示例: {pattern['sample_commands'][0][:50]}...")
                script.append(f"    # WorkBuddy方案: {mapping['workbuddy_approach']}")
                script.append("}")
                script.append("")
        
        # 主执行逻辑
        script.append("# 主执行逻辑")
        script.append("main() {")
        script.append('    echo "选择要迁移的模式:"')
        script.append('    echo "1. 全部模式"')
        
        for i, pattern in enumerate(analysis['common_patterns'], 2):
            category = pattern['category']
            if category in self.workbuddy_mapping:
                mapping = self.workbuddy_mapping[category]
                script.append(f'    echo "{i}. {mapping["description"]}"')
        
        script.append('    read -p "请输入选择 (默认: 1): " choice')
        script.append('    choice=${{choice:-1}}')
        script.append('')
        script.append('    case $choice in')
        script.append('        1)')
        for i, pattern in enumerate(analysis['common_patterns'], 1):
            category = pattern['category']
            if category in self.workbuddy_mapping:
                script.append(f'            migrate_{category}')
        script.append('            ;;')
        
        for i, pattern in enumerate(analysis['common_patterns'], 2):
            category = pattern['category']
            if category in self.workbuddy_mapping:
                script.append(f'        {i})')
                script.append(f'            migrate_{category}')
                script.append('            ;;')
        
        script.append('        *)')
        script.append('            echo "无效选择"')
        script.append('            ;;')
        script.append('    esac')
        script.append('}')
        script.append('')
        script.append('# 执行主函数')
        script.append('main "$@"')
        
        script_text = '\n'.join(script)
        
        if output_script:
            try:
                # 确保脚本可执行
                with open(output_script, 'w', encoding='utf-8') as f:
                    f.write(script_text)
                os.chmod(output_script, 0o755)
                print(f"迁移脚本已保存到: {output_script}")
            except Exception as e:
                print(f"保存脚本时出错: {e}")
        
        return script_text

def main():
    parser = argparse.ArgumentParser(description='分析Codex CLI使用历史并生成迁移建议')
    parser.add_argument('history_file', nargs='?', help='Codex历史文件路径')
    parser.add_argument('--output', '-o', help='输出报告文件路径')
    parser.add_argument('--script', '-s', help='生成迁移脚本路径')
    parser.add_argument('--verbose', '-v', action='store_true', help='显示详细信息')
    
    args = parser.parse_args()
    
    analyzer = CodexHistoryAnalyzer()
    
    # 查找或使用历史文件
    if args.history_file:
        history_files = [Path(args.history_file)]
    else:
        history_files = analyzer.find_history_files()
    
    if not history_files:
        print("未找到Codex历史文件。请提供文件路径或检查Codex CLI是否已安装。")
        print("尝试从终端历史查找codex命令...")
        # 可以尝试从当前shell历史查找
        import subprocess
        try:
            # 尝试获取bash历史
            result = subprocess.run(['bash', '-c', 'history | grep codex'], 
                                  capture_output=True, text=True)
            if result.stdout:
                commands = [line.strip() for line in result.stdout.split('\n') if line.strip()]
                if commands:
                    print(f"从shell历史中找到 {len(commands)} 个codex命令")
                    analysis = analyzer.analyze_commands(commands)
                    analyzer.generate_report(analysis, args.output)
                    if args.script:
                        analyzer.generate_migration_script(analysis, args.script)
                    sys.exit(0)
        except:
            pass
            
        print("请手动提供Codex历史文件路径。")
        sys.exit(1)
    
    # 分析所有找到的文件
    all_commands = []
    for hist_file in history_files:
        if args.verbose:
            print(f"分析文件: {hist_file}")
        
        commands = analyzer.extract_codex_commands(hist_file)
        if args.verbose:
            print(f"  找到 {len(commands)} 个codex命令")
        
        all_commands.extend(commands)
    
    # 去重
    unique_commands = list(dict.fromkeys(all_commands))
    
    if args.verbose:
        print(f"\n总共找到 {len(unique_commands)} 个唯一的codex命令")
    
    # 分析并生成报告
    analysis = analyzer.analyze_commands(unique_commands)
    analyzer.generate_report(analysis, args.output)
    
    # 生成迁移脚本
    if args.script:
        analyzer.generate_migration_script(analysis, args.script)
    
    # 显示摘要
    print(f"\n{'='*60}")
    print("分析摘要:")
    print(f"  分析命令总数: {analysis['total_commands']}")
    
    if analysis['total_commands'] > 0:
        print("  识别出的主要模式:")
        for pattern in analysis['common_patterns'][:3]:
            category = pattern['category']
            desc = analyzer.workbuddy_mapping.get(category, {'description': category})['description']
            print(f"    - {desc}: {pattern['count']}次 ({pattern['percentage']:.1f}%)")
    
    print(f"{'='*60}")

if __name__ == '__main__':
    main()