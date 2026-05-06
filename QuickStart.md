# CppGameDev Claude Code 插件

`CppGameDev` 是面向 C++ MMORPG 玩法服务器开发的 Claude Code 插件包。插件命名空间为 `cmg`，用于把玩法需求、缺陷诊断、代码审查、SVN 交付、经验沉淀以及策划案解析统一纳入一套可恢复、可审计的工作流。

## 命令说明

插件命令均使用 `/cmg:` 前缀。

- `/cmg:gp-design-parser`：独立策划案解析命令，适用于带批注、颜色标记、截图、表格或版本修订痕迹的玩法策划文档；该命令不会自动进入 `gp-intake` 工作流。
- `/cmg:gp-intake`：普通玩法任务入口。先生成 8 项玩法上下文卡片，再由路由器选择 `micro-plan`、`short-plan`、`full-plan` 或 `debugging-plan`。
- `/cmg:gp-debug`：用于根因尚不明确的玩法问题。先组织复现、日志、边界与调用链证据，再进入修复计划。
- `/cmg:gp-review`：执行项目代码审查、玩法风险审查与历史经验对齐。流程内审查写入 `05-review.md`；独立审查写入 `review.md`，不自动代表可交付或可提交。
- `/cmg:gp-svn-handoff`：用于一个完整功能或完整修复准备 SVN 交付时的交接总结，必须包含最新编译与验证证据。
- `/cmg:gp-compound`：将已经验证的、可复用的玩法经验写入宿主项目经验库。
- `/cmg:gp-compound-refresh`：维护宿主项目经验库，可执行保留、更新、合并或删除。

## 安装方式

在Claude Code中输入以下命令

```text
/plugin marketplace add I:\CppGameDev
/plugin install cmg@foryoung365-plugins
/reload-plugins
```

安装后，在宿主项目中启动 Claude Code，并通过 `/help` 或直接输入 `/cmg:gp-intake` 验证命名空间是否可用。


### 3. 离线升级

升级时重新生成并转移新的 `cmg-<version>.zip`，在离线机器上解压到新的目录或替换原目录，然后再次执行：

```text
/plugin marketplace add D:\ClaudePlugins\cmg
/plugin install cmg@foryoung365-plugins
```

若 Claude Code 已缓存旧版本，请优先确认 `/help` 中显示的命令是否已更新，并检查解压目录中的 `.claude-plugin/plugin.json` 版本号。


## 推荐使用流程

普通功能或修复任务建议按以下顺序使用：

0. 使用 `/cmg:gp-design-parser` 解析策划案，会在项目根目录的 `docs/design` 目录下生成实现文档。
1. 使用 `/cmg:gp-intake` 分析步骤0生成的实现文档 建立上下文卡片和任务路线。
2. 根据路由结果完成 `03-plan.md`，并写明 `Performance impact`，再开始代码修改。
3. 修改过程中持续维护 `04-progress.md`，在实现确认、改变或排除性能影响时记录 `Performance notes`。
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
- `03-plan.md`：可执行实现计划；代码修改前必须存在，并包含 `Performance impact`。不要求达到固定性能指标，但必须说明性能影响或明确标记不适用。
- `04-progress.md`：执行进度、阻塞、下一步、验证状态和 `Performance notes`。
- `05-review.md`：审查发现、Review scope coverage、残余风险与验证缺口。
- `06-handoff.md`：交付摘要、最新编译证据、验证证据、风险与回滚说明。

如果宿主项目的 `claude.md` 明确覆盖了任务文档根目录，应以宿主项目配置为准。

独立 `/cmg:gp-review` 可以在任务根目录下创建 `YYYY-MM-DD-review-<slug>/review.md`，用于只审查 diff、文件集或当前改动。主代理可在审查质量需要时补齐最小必要阶段文档，但独立审查不会自动升级为交付结论。

## 宿主项目经验库

插件支持宿主项目经验检索与经验写入。经验文档位于宿主项目，不位于本插件仓库。

默认经验库路径为：

```text
docs/cmg/solutions/bugs/
docs/cmg/solutions/patterns/
```

`gp-experience-researcher` 的检索范围固定限制在宿主项目 `docs/cmg/solutions/**`。不得扩展到任务文档、源码、日志、构建输出、插件仓库或由 `claude.md` 指向的其他目录。

历史经验只作为二级上下文；当前代码、当前证据与当前验证始终拥有更高优先级。`gp-compound` 只应写入已经具备明确证据、明确结论与明确验证的可复用经验，不应写入临时观察、猜测、实验建议或单次功能实现记录。

