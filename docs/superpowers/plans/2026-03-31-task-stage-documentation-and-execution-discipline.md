# 任务阶段文档与执行纪律实施计划

> 历史说明：本文为任务阶段文档落地阶段的内部实施计划中文整理版。

## 目标

让每一次 gameplay 任务的阶段切换都持久化到宿主项目任务文档中，使代理在上下文压缩后仍能恢复计划、验证与编译门禁，而不是依赖会话记忆。

## 架构摘要

- 增加一个运行时技能，统一定义宿主项目任务目录与必需阶段文件
- 将所有命令与计划形态接入该任务目录模型
- 强化执行规则：磁盘上的计划、进展与新鲜编译证据，均成为 ready-for-delivery 的前置条件

## 技术栈

- Claude Code 插件 Markdown 资产
- PowerShell 校验脚本
- Windows 批处理打包

## 核心任务目录模型

默认任务根目录：

```text
docs/cmg/tasks/<task-slug>/
  00-context.md
  01-pre-plan.md
  02-debug.md
  03-plan.md
  04-progress.md
  05-review.md
  06-handoff.md
```

若当前宿主项目的 `claude.md` 定义了任务文档根目录，则以其覆盖默认路径。

## 关键规则

- `00-context.md` 必须先于 `01-pre-plan.md`
- 在进入 `micro-plan`、`short-plan`、`full-plan` 或 `debugging-plan` 之前，必须存在 `01-pre-plan.md`
- 离开调试阶段之前，必须有 `02-debug.md`
- 任何代码修改前，必须有 `03-plan.md`
- 执行推进过程中，必须持续更新 `04-progress.md`
- 在进入 `06-handoff.md` 前，必须完成 `05-review.md`
- 若代码发生变更，没有新鲜编译证据，则 `06-handoff.md` 不得宣称 ready

## 恢复规则

在上下文压缩、会话重启或代理交接之后：

1. 重新加载任务目录
2. 阅读最新阶段文档
3. 从最后一个未完成阶段继续
4. 不依赖记忆重建计划状态

## 关键任务

### 任务 1：建立宿主项目任务阶段运行时契约

- 编写 `gp-task-stage-discipline`
- 编写阶段模板
- 在 `gameplay-main`、`README.md` 与操作员文档中同步任务目录模型

### 任务 2：让 intake 与各计划形态落盘

- `gp-intake` 必须负责解析任务根目录并创建任务目录
- `task-intake-router` 必须将 `pre-plan` 落盘
- `micro-plan`、`short-plan` 与 `debugging-plan` 均不得只停留在会话上下文中
- `03-plan.md` 必须在修改前存在，并写明精确文件与验证步骤

### 任务 3：让调试、进展、审查与交接全部落盘

- `gp-debug` 与 `systematic-debugging` 必须维护 `02-debug.md`
- 执行流必须维护 `04-progress.md`
- `gp-review` 必须维护 `05-review.md`
- `gp-svn-handoff` 必须维护 `06-handoff.md`

## 预期结果

完成后，任何 gameplay 任务都应具备以下特征：

- 从受理到交接的每个阶段均有可恢复文档
- 代码修改必须先有磁盘上的计划
- 调试结论必须先有磁盘上的根因记录
- 交接结论必须附带新鲜编译证据与验证证据
