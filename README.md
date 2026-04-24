# CppGameDev Claude Code 插件

`CppGameDev` 是面向 C++ MMORPG 玩法服务器开发的 Claude Code 插件包。插件命名空间为 `cmg`，用于把玩法需求、缺陷诊断、代码审查、SVN 交付、经验沉淀以及策划案解析统一纳入一套可恢复、可审计的工作流。

本仓库是一个 Claude Code 插件包，不是宿主项目中的 `.claude/` 覆盖目录。插件已将上游 Superpowers 与 ECC 相关思路整理为本地运行资产，交付包中不包含上游仓库副本。

## 主要能力

- 玩法任务入口治理：通过 `request -> gameplay-context-guard -> task-intake-router -> pre-plan` 建立上下文卡片与任务路线。
- 任务阶段文档：在宿主项目中维护 `00-context.md` 到 `06-handoff.md`，用于长任务恢复、上下文压缩恢复以及交付审计。
- C++ 与玩法审查：结合 `cpp-reviewer`、`gameplay-reviewer`、`checklist-reviewer` 与 `gp-review-checklist` 输出审查结论。
- SVN 交付约束：以 feature-sized 为交付粒度，每次提交只对应 one complete feature or one complete fix。
- 编译与验证门禁：任何 commit-ready 结论之前都需要 fresh successful compile，并且编译成功不能替代 targeted validation。
- 宿主项目经验库：支持检索和写入可复用的玩法经验文档，经验位于宿主项目而非插件仓库。
- 独立策划案解析：通过 `/cmg:gp-design-parser` 调用独立技能，解析带批注、颜色标记、版本变更、截图和表格的 MMORPG 或玩法策划文档。

## 目录结构

- `.claude-plugin/plugin.json`：插件清单，当前插件名为 `cmg`。
- `.claude-plugin/marketplace.json`：本地或 GitHub marketplace 目录，安装名为 `cmg@foryoung365-plugins`。
- `commands/`：对外 `/cmg:*` 命令入口。
- `agents/`：主代理与审查、构建、日志、经验检索等辅助代理。
- `skills/`：插件运行技能及其随附模板、参考材料和工具。
- `settings.json`：插件默认主代理配置。
- `docs/operator/quickstart.md`：操作者快速说明。
- `docs/workflow/`、`docs/gameplay/`、`docs/svn/`：面向人员阅读的流程镜像文档。
- `scripts/package-plugin.bat`：生成离线安装 zip，并自动递增补丁版本号。
- `scripts/verify-toolkit.ps1`：结构与关键语义校验脚本。
- `tests/`：验证脚本使用的测试夹具，不会进入离线运行包。

已发布文档仅用于人员阅读；运行权威仍以插件资产为准，包括 `commands/`、`agents/`、`skills/` 与 `.claude-plugin/` 下的清单文件。


## 安装方式

### 1. 通过本地 marketplace 安装

适合在同一台机器上将本仓库作为本地插件源使用。

```text
/plugin marketplace add I:\CppGameDev
/plugin install cmg@foryoung365-plugins
/reload-plugins
```

安装后，在宿主项目中启动 Claude Code，并通过 `/help` 或直接输入 `/cmg:gp-intake` 验证命名空间是否可用。

### 2. 通过 GitHub marketplace 安装

适合允许 Claude Code 从远程仓库拉取插件的环境。

```text
/plugin marketplace add foryoung365/CppGameDev-skill
/plugin install cmg@foryoung365-plugins
```

`.claude-plugin/marketplace.json` 使用相对插件源 `./`，因此同一份 marketplace 清单既适用于本地文件系统路径，也适用于 Claude Code 从 GitHub 克隆得到的仓库副本。

### 3. 离线升级

升级时重新生成并转移新的 `cmg-<version>.zip`，在离线机器上解压到新的目录或替换原目录，然后再次执行：

```text
/plugin marketplace add D:\ClaudePlugins\cmg
/plugin install cmg@foryoung365-plugins
```

若 Claude Code 已缓存旧版本，请优先确认 `/help` 中显示的命令是否已更新，并检查解压目录中的 `.claude-plugin/plugin.json` 版本号。

## 命令说明

插件命令均使用 `/cmg:` 前缀。

- `/cmg:gp-design-parser`：独立策划案解析命令，适用于带批注、颜色标记、截图、表格或版本修订痕迹的玩法策划文档；该命令不会自动进入 `gp-intake` 工作流。
- `/cmg:gp-intake`：普通玩法任务入口。先生成 8 项玩法上下文卡片，再由路由器选择 `micro-plan`、`short-plan`、`full-plan` 或 `debugging-plan`。
- `/cmg:gp-debug`：用于根因尚不明确的玩法问题。先组织复现、日志、边界与调用链证据，再进入修复计划。
- `/cmg:gp-review`：执行 C++ 审查、玩法风险审查、清单审查与历史经验对齐，并将主代理接受的结果写入 `05-review.md`。
- `/cmg:gp-svn-handoff`：用于一个完整功能或完整修复准备 SVN 交付时的交接总结，必须包含最新编译与验证证据。
- `/cmg:gp-compound`：将已经验证的、可复用的玩法经验写入宿主项目经验库。
- `/cmg:gp-compound-refresh`：维护宿主项目经验库，可执行保留、更新、合并或删除。


## 推荐使用流程

普通功能或修复任务建议按以下顺序使用：

0. 使用 `/cmg:gp-design-parser` 解析策划案，会在项目根目录的 `docs/design` 目录下生成实现文档。
1. 使用 `/cmg:gp-intake` 分析步骤0生成的实现文档 建立上下文卡片和任务路线。
2. 根据路由结果完成 `03-plan.md`，再开始代码修改。
3. 修改过程中持续维护 `04-progress.md`。
4. 使用 `/cmg:gp-review` 形成审查结论与残余风险记录。
5. 编译与目标验证通过后，使用 `/cmg:gp-svn-handoff` 准备交付摘要。
6. 若本次任务沉淀出可复用经验，再使用 `/cmg:gp-compound` 写入宿主项目经验库。

根因不明确的问题应优先使用 `/cmg:gp-debug`，并在 `02-debug.md` 中明确症状、复现路径、证据与最终根因后，再进入修复计划。

只需要处理策划案时，直接使用 `/cmg:gp-design-parser <策划文档路径或说明>`；除非明确要求组合流程，否则它不会创建任务阶段文档，也不会触发审查或 SVN 交付流程。

## 宿主项目任务文档

插件默认在宿主项目中维护任务阶段文档，默认根目录为：

```text
docs/cmg/tasks/
```

每个任务使用一个带日期的目录：

```text
docs/cmg/tasks/YYYY-MM-DD-<task-slug>/
```

阶段文件如下：

- `00-context.md`：玩法上下文卡片。
- `01-pre-plan.md`：路由结果与主代理接受的 `pre-plan`。
- `02-debug.md`：调试证据、复现、根因定位过程。
- `03-plan.md`：可执行实现计划；代码修改前必须存在。
- `04-progress.md`：执行进度、阻塞、下一步和验证状态。
- `05-review.md`：审查发现、Checklist coverage、残余风险与验证缺口。
- `06-handoff.md`：交付摘要、最新编译证据、验证证据、风险与回滚说明。

如果宿主项目的 `claude.md` 明确覆盖了任务文档根目录，应以宿主项目配置为准。

## 宿主项目经验库

插件支持宿主项目经验检索与经验写入。经验文档位于宿主项目，不位于本插件仓库。

默认经验库路径为：

```text
docs/cmg/solutions/bugs/
docs/cmg/solutions/patterns/
```

历史经验只作为二级上下文；当前代码、当前证据与当前验证始终拥有更高优先级。`gp-compound` 只应写入已经具备明确证据、明确结论与明确验证的可复用经验，不应写入临时观察、猜测、实验建议或单次功能实现记录。

## 运行规则摘要

- 主代理负责所有阶段推进和最终判断；子代理可以收集证据、草拟结论或执行有限支持工作，但不能单独推进任务状态。
- 任务入口链路固定为 `request -> gameplay-context-guard -> task-intake-router -> pre-plan`。
- SVN 交付保持 feature-sized 粒度，提交只允许对应 one complete feature or one complete fix。
- 任何 commit-ready 结论都需要 fresh successful compile；targeted validation 仍然必须依据改动风险单独完成。
- 插件不定义宿主项目的构建命令；编译证据应来自宿主项目的标准构建脚本、`claude.md` 或等价本地配置。
- 发布文档只提供人员阅读视图；如文档与运行资产不一致，应优先修正运行资产，再同步文档。

## 校验与发布

结构校验：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify-toolkit.ps1
```

本地 smoke test：

```powershell
claude --plugin-dir I:\CppGameDev
```

生成离线发布包：

```powershell
scripts\package-plugin.bat
```

离线包只包含插件运行资产、发布文档和 marketplace 清单，不包含宿主项目任务文档、宿主项目经验库、测试夹具或内部维护文档。

## 发布边界

会随插件发布的内容：

- `skills/`
- `agents/`
- `commands/`
- `settings.json`
- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md`
- `docs/operator/quickstart.md`
- `docs/workflow/request-lifecycle.md`
- `docs/gameplay/context-card.md`
- `docs/svn/commit-policy.md`

仅供仓库维护使用的内容：

- `docs/upstream-mapping.md`
- `docs/superpowers/`
- `tests/`
- `scripts/verify-toolkit.ps1`
- `scripts/package-plugin.bat`

## 常见问题

### `/cmg:*` 命令不可见

请确认安装目录根部直接包含 `.claude-plugin/marketplace.json` 和 `.claude-plugin/plugin.json`，并重新执行：

```text
/plugin marketplace add <插件目录>
/plugin install cmg@foryoung365-plugins
```

也可以使用 `claude --plugin-dir <插件目录>` 临时加载，以判断问题是安装缓存还是包内容。

### 离线安装后提示找不到技能

请确认使用的是 `1.0.18` 或更新版本。本插件运行提示已经改为按技能名和代理名调用，避免在离线安装后依赖源码仓库中的相对路径。若仍出现问题，请检查解压目录是否完整包含 `skills/`、`agents/` 与 `commands/`。

### 打包后版本号发生变化

`scripts\package-plugin.bat` 会自动递增补丁版本号，并同步更新 `.claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json`。这是发布流程的一部分。

### zip 没有进入版本库提交

`dist/` 目录通常用于本地发布产物，仓库默认不会提交生成的 zip。需要分发离线包时，请直接使用 `dist\cmg-<version>.zip`。
