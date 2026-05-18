---
name: edgeone-pages
description: "EdgeOne Pages is a dedicated service that quickly deploys full-stack projects to EdgeOne Pages and generates preview links, enabling you to immediately leverage the powerful capabilities provided by EdgeOne Pages."
description_zh: "EdgeOne Pages是一项专用服务，能够将全栈项目快速部署到 EdgeOne Pages 并生成预览链接，使您能够立即使用到 EdgeOne Pages 提供的强大能力。"
description_en: "EdgeOne Pages is a dedicated service that quickly deploys full-stack projects to EdgeOne Pages and generates preview links, enabling you to immediately leverage the powerful capabilities provided by EdgeOne Pages."
version: "1.0.0"
---

# EdgeOne Pages Skill

该 Skill 需要调用 `edgeone-pages-mcp-server` MCP Server。

## 概述

EdgeOne Pages 是一项专用服务，能够将全栈项目快速部署到 EdgeOne Pages 并生成预览链接，使您能够立即使用到 EdgeOne Pages 提供的强大能力。

## 核心能力

- **全栈项目部署**：将全栈项目（React、Vue、Next.js、Nuxt、Vite 等）快速部署到 EdgeOne Pages
- **预览链接生成**：部署完成后自动生成预览链接，即时查看效果
- **框架自动识别**：自动检测项目框架类型并使用最佳构建配置
- **边缘加速**：利用 EdgeOne 全球边缘节点提供高性能访问
- **部署管理**：查看部署历史、回滚到指定版本、管理部署环境

## 使用原则

1. 部署前确认项目类型和构建配置
2. 优先使用框架自动识别功能，减少手动配置
3. 部署后通过生成的预览链接确认效果

## 典型工作流

1. **快速部署**：选择项目 → 自动识别框架 → 部署 → 获取预览链接
2. **更新部署**：修改代码 → 触发重新部署 → 通过预览链接确认
3. **版本回滚**：查看部署历史 → 选择目标版本 → 回滚部署
