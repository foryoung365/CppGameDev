Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$script:Results = @()

function Assert-Condition {
	param(
		[bool]$Condition,
		[string]$Message
	)

	if (-not $Condition) {
		throw $Message
	}
}

function Invoke-ToolkitCheck {
	param(
		[string]$Name,
		[scriptblock]$Action
	)

	try {
		& $Action
		$script:Results += [pscustomobject]@{
			Name = $Name
			Status = 'PASS'
			Details = ''
		}
	} catch {
		$script:Results += [pscustomobject]@{
			Name = $Name
			Status = 'FAIL'
			Details = $_.Exception.Message
		}
	}
}

function Get-FileText {
	param(
		[string]$Path
	)

	return [System.IO.File]::ReadAllText($Path)
}

function Remove-DirectoryIfPresent {
	param(
		[string]$Path
	)

	if (Test-Path -LiteralPath $Path) {
		Remove-Item -LiteralPath $Path -Recurse -Force
	}
}

function Get-SkillFiles {
	$skillRoot = Join-Path $repoRoot 'skills'
	Assert-Condition (Test-Path -LiteralPath $skillRoot) "Missing skills directory: $skillRoot"
	return @(Get-ChildItem -LiteralPath $skillRoot -Recurse -File -Filter 'SKILL.md' | Sort-Object FullName)
}

function Get-RuntimeTextFiles {
	$files = @()

	$files += @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'skills') -Recurse -File -Filter 'SKILL.md')
	$files += @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'agents') -File -Filter '*.md')
	$files += @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'commands') -File -Filter '*.md')
	$files += @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'docs\operator') -Recurse -File -Filter '*.md')

	$topLevelFiles = @(
		'QuickStart.md',
		'docs/upstream-mapping.md',
		'docs/workflow/request-lifecycle.md',
		'docs/svn/commit-policy.md',
		'docs/gameplay/context-card.md'
	)

	foreach ($relativePath in $topLevelFiles) {
		$fullPath = Join-Path $repoRoot $relativePath
		if (Test-Path -LiteralPath $fullPath) {
			$files += Get-Item -LiteralPath $fullPath
		}
	}

	return @($files | Sort-Object FullName -Unique)
}

function Test-SkillFrontMatter {
	param(
		[string]$Path
	)

	$lines = @(Get-Content -LiteralPath $Path -TotalCount 20)
	Assert-Condition ($lines.Count -ge 3) "${Path}: frontmatter is missing or too short"
	Assert-Condition ($lines[0] -eq '---') "${Path}: frontmatter must start with ---"

	$closingIndex = [Array]::IndexOf($lines, '---', 1)
	Assert-Condition ($closingIndex -gt 0) "${Path}: frontmatter must end with ---"

	$frontMatter = $lines[1..($closingIndex - 1)] -join "`n"
	Assert-Condition ($frontMatter -match '(?m)^name:\s*\S+') "${Path}: frontmatter is missing name"
	Assert-Condition ($frontMatter -match '(?m)^description:\s*\S+') "${Path}: frontmatter is missing description"
}

Invoke-ToolkitCheck 'plugin structure and manifest are valid' {
	$requiredPaths = @(
		'.claude-plugin\plugin.json',
		'.claude-plugin\marketplace.json',
		'settings.json',
		'scripts\package-plugin.bat',
		'QuickStart.md',
		'skills',
		'agents',
		'commands',
		'docs\operator\quickstart.md',
		'commands\gp-design-parser.md',
		'skills\gp-compound\SKILL.md',
		'skills\gp-compound\assets\bug-track-template.md',
		'skills\gp-compound\assets\knowledge-track-template.md',
		'skills\gp-compound\references\experience-schema.md',
		'skills\gp-compound-refresh\SKILL.md',
		'skills\gp-compound-refresh\references\refresh-rules.md',
		'skills\gp-experience-researcher\SKILL.md',
		'skills\gp-subagent-orchestration\SKILL.md',
		'skills\gp-subagent-orchestration\references\delegation-matrix.md',
		'skills\gp-task-stage-discipline\SKILL.md',
		'skills\gp-task-stage-discipline\references\task-stage-templates.md',
		'skills\gp-design-parser\SKILL.md',
		'skills\gp-design-parser\implementation-doc-template.md',
		'skills\gp-design-parser\bin\pdf-to-annotated-markdown.exe',
		'agents\code-reviewer.md',
		'agents\gp-experience-researcher.md',
		'commands\gp-compound.md',
		'commands\gp-compound-refresh.md',
		'tests\fixtures\experience\host-project\docs\cmg\solutions\bugs\combat\buff-remove-ordering-2026-03-30.md',
		'tests\fixtures\experience\host-project\docs\cmg\solutions\patterns\workflow\evidence-before-compound-2026-03-30.md'
	)

	$missing = @()
	foreach ($relativePath in $requiredPaths) {
		$fullPath = Join-Path $repoRoot $relativePath
		if (-not (Test-Path -LiteralPath $fullPath)) {
			$missing += $relativePath
		}
	}

	Assert-Condition ($missing.Count -eq 0) ('Missing required plugin paths: ' + ($missing -join ', '))

	$forbiddenPaths = @(
		'AGENTS.md',
		'CLAUDE.md',
		'rules'
	)

	$hits = @()
	foreach ($relativePath in $forbiddenPaths) {
		$fullPath = Join-Path $repoRoot $relativePath
		if (Test-Path -LiteralPath $fullPath) {
			$hits += $relativePath
		}
	}

	Assert-Condition ($hits.Count -eq 0) ('Retired paths must not exist: ' + ($hits -join ', '))

	$plugin = Get-Content -Raw -LiteralPath (Join-Path $repoRoot '.claude-plugin\plugin.json') | ConvertFrom-Json
	Assert-Condition ($plugin.name -eq 'cmg') 'plugin.json name must be cmg'
	Assert-Condition (-not [string]::IsNullOrWhiteSpace($plugin.description)) 'plugin.json description is required'
	Assert-Condition (-not [string]::IsNullOrWhiteSpace($plugin.version)) 'plugin.json version is required'
	Assert-Condition (-not [string]::IsNullOrWhiteSpace($plugin.homepage)) 'plugin.json homepage is required'
	Assert-Condition (-not [string]::IsNullOrWhiteSpace($plugin.repository)) 'plugin.json repository is required'

	$marketplace = Get-Content -Raw -LiteralPath (Join-Path $repoRoot '.claude-plugin\marketplace.json') | ConvertFrom-Json
	Assert-Condition ($marketplace.name -eq 'foryoung365-plugins') 'marketplace.json name must be foryoung365-plugins'
	Assert-Condition ($marketplace.plugins.Count -gt 0) 'marketplace.json must include at least one plugin entry'
	$pluginEntry = @($marketplace.plugins | Where-Object name -eq 'cmg')
	Assert-Condition ($pluginEntry.Count -eq 1) 'marketplace.json must include exactly one cmg entry'
	Assert-Condition ($pluginEntry[0].source -eq './') 'marketplace plugin entry must use relative source ./'
	Assert-Condition ($marketplace.metadata.version -eq $plugin.version) 'marketplace metadata version must match plugin.json version'
	Assert-Condition ($pluginEntry[0].version -eq $plugin.version) 'marketplace plugin entry version must match plugin.json version'

	$settings = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'settings.json') | ConvertFrom-Json
	Assert-Condition (-not [string]::IsNullOrWhiteSpace($settings.agent)) 'settings.json must define agent'
	$agentFile = Join-Path $repoRoot ("agents\{0}.md" -f $settings.agent)
	Assert-Condition (Test-Path -LiteralPath $agentFile) "settings.json agent target is missing: $agentFile"
}

Invoke-ToolkitCheck 'toolkit skill frontmatter' {
	$skillFiles = Get-SkillFiles
	Assert-Condition ($skillFiles.Count -gt 0) 'No toolkit skills were found under skills/'

	$missing = @()
	foreach ($skillFile in $skillFiles) {
		try {
			Test-SkillFrontMatter -Path $skillFile.FullName
		} catch {
			$missing += $_.Exception.Message
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'runtime wording avoids stale git/worktree/PR flow terms' {
	$runtimeFiles = Get-RuntimeTextFiles
	$stalePatterns = @(
		'\bgit\b',
		'worktree',
		'pull request',
		'\bPR\b',
		'feature branch',
		'base branch',
		'development branch',
		'branch cleanup',
		'\bmerge\b',
		'\brebase\b',
		'\bcherry-pick\b'
	)

	$hits = @()
	foreach ($file in $runtimeFiles) {
		$text = Get-FileText -Path $file.FullName
		foreach ($pattern in $stalePatterns) {
			if ($text -match $pattern) {
				$hits += "$($file.FullName): matched $pattern"
			}
		}
	}

	Assert-Condition ($hits.Count -eq 0) ($hits -join '; ')
}

Invoke-ToolkitCheck 'toolkit remains self-contained without vendored upstream repos' {
	$unexpectedPaths = @(
		'.repo-context',
		'references',
		'references/superpowers',
		'references/ecc-cpp',
		'cpp-coding-standards-skill',
		'docs\solutions'
	)

	$hits = @()
	foreach ($relativePath in $unexpectedPaths) {
		$fullPath = Join-Path $repoRoot $relativePath
		if (Test-Path -LiteralPath $fullPath) {
			$hits += $relativePath
		}
	}

	Assert-Condition ($hits.Count -eq 0) ('Vendored upstream content should not exist inside the toolkit: ' + ($hits -join ', '))
}

Invoke-ToolkitCheck 'runtime intake chain stays intact in plugin authorities' {
	$chainPattern = 'request\s*->\s*gameplay-context-guard\s*->\s*task-intake-router\s*->\s*pre-plan'
	$keyFiles = @(
		'agents/gameplay-main.md',
		'docs/workflow/request-lifecycle.md'
	)

	$missing = @()
	foreach ($relativePath in $keyFiles) {
		$fullPath = Join-Path $repoRoot $relativePath
		$text = Get-FileText -Path $fullPath
		if ($text -notmatch $chainPattern) {
			$missing += "$relativePath missing request -> gameplay-context-guard -> task-intake-router -> pre-plan"
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'project-first governance stays explicit in runtime authorities' {
	$keyFiles = @(
		'agents/gameplay-main.md',
		'skills/cpp-coding-standards/SKILL.md'
	)

	$missing = @()
	foreach ($relativePath in $keyFiles) {
		$text = Get-FileText -Path (Join-Path $repoRoot $relativePath)
		$patterns = switch ($relativePath) {
			default { @('Project conventions override imported generic defaults', 'Project-local conventions are the default') }
		}
		$matched = $false
		foreach ($pattern in $patterns) {
			if ($text -match [regex]::Escape($pattern)) {
				$matched = $true
				break
			}
		}
		if (-not $matched) {
			$missing += "$relativePath missing project-first governance wording"
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'routing vocabulary uses approved plan names' {
	$routingFiles = @(
		'docs/workflow/request-lifecycle.md',
		'skills/task-intake-router/SKILL.md',
		'skills/lightweight-change-flow/SKILL.md',
		'skills/standard-feature-flow/SKILL.md',
		'skills/systematic-debugging/SKILL.md',
		'agents/gameplay-main.md'
	)

	$requirements = [ordered]@{
		'docs/workflow/request-lifecycle.md' = @('micro-plan', 'short-plan', 'full-plan', 'debugging-plan')
		'skills/task-intake-router/SKILL.md' = @('micro-plan', 'short-plan', 'full-plan', 'debugging-plan', 'pre-plan')
		'skills/lightweight-change-flow/SKILL.md' = @('micro-plan')
		'skills/standard-feature-flow/SKILL.md' = @('short-plan')
		'skills/systematic-debugging/SKILL.md' = @('debugging-plan')
		'agents/gameplay-main.md' = @('micro-plan', 'short-plan', 'full-plan', 'debugging-plan', 'pre-plan')
	}

	$missing = @()
	foreach ($relativePath in $routingFiles) {
		$fullPath = Join-Path $repoRoot $relativePath
		$text = Get-FileText -Path $fullPath
		foreach ($term in $requirements[$relativePath]) {
			if ($text -notmatch [regex]::Escape($term)) {
				$missing += "$relativePath missing $term"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'svn delivery remains feature-sized in runtime files' {
	$files = @(
		'agents/gameplay-main.md',
		'docs/svn/commit-policy.md',
		'skills/svn-delivery-handoff/SKILL.md',
		'skills/verification-before-completion/SKILL.md'
	)

	$requiredPatterns = @(
		'feature-sized',
		'one complete feature or one complete fix'
	)

	$missing = @()
	foreach ($relativePath in $files) {
		$text = Get-FileText -Path (Join-Path $repoRoot $relativePath)
		foreach ($pattern in $requiredPatterns) {
			if ($text -notmatch [regex]::Escape($pattern)) {
				$missing += "$relativePath missing $pattern"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'commit gate semantic trio stays aligned across runtime files' {
	$gateFiles = @(
		'agents/gameplay-main.md',
		'docs/svn/commit-policy.md',
		'skills/verification-before-completion/SKILL.md'
	)

	$requiredPhrases = @(
		'fresh successful compile',
		'commit-ready',
		'targeted validation'
	)

	$missing = @()
	foreach ($relativePath in $gateFiles) {
		$text = Get-FileText -Path (Join-Path $repoRoot $relativePath)
		foreach ($phrase in $requiredPhrases) {
			if ($text -notmatch [regex]::Escape($phrase)) {
				$missing += "$relativePath missing $phrase"
			}
		}
	}

	$handoffPath = Join-Path $repoRoot 'skills/svn-delivery-handoff/SKILL.md'
	$handoffText = Get-FileText -Path $handoffPath
	if ($handoffText -notmatch 'fresh successful compile') {
		$missing += 'skills/svn-delivery-handoff/SKILL.md missing fresh successful compile'
	}
	if ($handoffText -notmatch 'Validation evidence|Fresh successful compile evidence') {
		$missing += 'skills/svn-delivery-handoff/SKILL.md missing validation evidence text'
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'published docs are marked human-facing and not sole runtime authority' {
	$checks = @(
		@{
			Path = 'docs/operator/quickstart.md'
			Pattern = 'Runtime authority still lives in plugin assets'
		},
		@{
			Path = 'docs/upstream-mapping.md'
			Pattern = 'internal maintainer provenance only'
		},
		@{
			Path = 'docs/workflow/request-lifecycle.md'
			Pattern = 'Runtime authority still lives in plugin assets'
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		if ($text -notmatch [regex]::Escape($check.Pattern)) {
			$missing += "$($check.Path) missing $($check.Pattern)"
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'experience runtime contract stays host-project scoped and evidence-second' {
	$checks = @(
		@{
			Path = 'agents/gameplay-main.md'
			Needles = @(
				'Historical experience is secondary context only.',
				'Current code, current logs, current reproduction evidence, and current validation outrank historical experience.',
				'`gp-experience-researcher` search is limited to the active host project''s `docs/cmg/solutions/**` subtree.',
				'Do not expand experience retrieval to task docs, source files, logs, build output, the plugin repository, or a custom path from `claude.md`.',
				'docs/cmg/solutions/bugs/',
				'docs/cmg/solutions/patterns/'
			)
		},
		@{
			Path = 'agents/gp-experience-researcher.md'
			Needles = @(
				'only under the active host project''s `docs/cmg/solutions/**` subtree',
				'Search only the host project''s `docs/cmg/solutions/**` subtree',
				'Do not use `claude.md` or local configuration to widen the search root for this researcher.'
			)
		},
		@{
			Path = 'skills/gp-experience-researcher/SKILL.md'
			Needles = @(
				'Historical experience never outranks:',
				'Search only the active host project''s fixed experience library subtree:',
				'docs/cmg/solutions/**',
				'Do not expand the search to task docs, source files, logs, build output, the plugin repository, or any other directory.',
				'Do not use `claude.md` or local configuration to widen the search root for this researcher.',
				'docs/cmg/solutions/bugs/',
				'docs/cmg/solutions/patterns/'
			)
		},
		@{
			Path = 'skills/gp-compound/SKILL.md'
			Needles = @(
				'Write experience documents into the **host project**, not into this plugin repository.',
				'Do not create or update any experience document unless **all three** are true:',
				'the evidence is explicit',
				'the conclusion is explicit',
				'the validation is explicit',
				'feature implementation walkthroughs',
				'If removing the current feature name makes the document meaningless, refuse to write it.',
				'Do **not** derive experience docs from:',
				'the current task''s `05-review.md`',
				'the current task''s `06-handoff.md`',
				'raw `04-progress.md` execution notes'
			)
		},
		@{
			Path = 'skills/evidence-first-change-validation/SKILL.md'
			Needles = @(
				'Historical experience can inform validation choices, but current validated evidence outranks historical experience every time.'
			)
		},
		@{
			Path = 'docs/operator/quickstart.md'
			Needles = @(
				'This plugin can retrieve and write verified gameplay experience docs',
				'the library lives in the **host project**, not in this plugin repository.',
				'Historical experience is secondary context only. Current code, current evidence, and current validation remain authoritative.'
			)
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($needle in $check.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($check.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'subagent orchestration contract stays explicit in runtime files' {
	$checks = @(
		@{
			Path = 'agents/gameplay-main.md'
			Needles = @(
				'Use `gp-subagent-orchestration` when delegation helps, but keep all final judgments in the main agent.',
				'Subagents may gather evidence, propose conclusions, draft summaries, or perform bounded execution, but they do not advance the task by themselves.'
			)
		},
		@{
			Path = 'skills/gp-subagent-orchestration/SKILL.md'
			Needles = @(
				'The main agent owns every judgment that changes task state.',
				'Only the main agent may decide:',
				'A subagent result is only supporting material until the main agent does both of these:',
				'Without that main-agent acceptance step, the task has not advanced.'
			)
		},
		@{
			Path = 'skills/gp-subagent-orchestration/references/delegation-matrix.md'
			Needles = @(
				'## `gp-intake`',
				'## `gp-debug`',
				'## `03-plan.md`',
				'## `gp-review`',
				'## `gp-svn-handoff`',
				'## `gp-compound`'
			)
		},
		@{
			Path = 'commands/gp-intake.md'
			Needles = @(
				'main agent as the only decision-maker',
				'they must not make the stage call or write the accepted stage conclusion'
			)
		},
		@{
			Path = 'commands/gp-debug.md'
			Needles = @(
				'candidate leads, not proof',
				'the main agent must accept the evidence and choose the diagnosis'
			)
		},
		@{
			Path = 'commands/gp-review.md'
			Needles = @(
				'main agent decide which findings are accepted and severity-ranked',
				'they must not finalize the review'
			)
		},
		@{
			Path = 'commands/gp-svn-handoff.md'
			Needles = @(
				'subagents can only gather evidence and summarize candidates',
				'Do not present partial work as delivery-ready, and do not let subagent output alone move the task into handoff.'
			)
		},
		@{
			Path = 'commands/gp-compound.md'
			Needles = @(
				'Treat `gp-compound` as a main-agent decision point',
				'only the main agent may accept the final lesson and write it into the experience library'
			)
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($needle in $check.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($check.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'parallel delegation preference stays explicit in runtime files' {
	$checks = @(
		@{
			Path = 'agents/gameplay-main.md'
			Needles = @(
				'Prefer parallel delegation whenever two or more bounded supporting tasks are independent and the next main-agent decision can wait for their combined results.'
			)
		},
		@{
			Path = 'skills/gp-subagent-orchestration/SKILL.md'
			Needles = @(
				'When two or more bounded supporting tasks are independent, prefer delegating them in parallel.',
				'Converge the parallel work at the next main-agent decision point instead of serializing unrelated support tasks by default.'
			)
		},
		@{
			Path = 'skills/gp-subagent-orchestration/references/delegation-matrix.md'
			Needles = @(
				'run independent support tasks in parallel when the context card inputs are stable',
				'run independent reproductions, log extraction, trace comparison, and related-learning retrieval in parallel when they do not depend on each other',
				'run independent planning support tasks in parallel after the main agent approves scope',
				'run `bounded review draft`, `evidence collation`, and `prior-learning alignment summary` in parallel whenever the review scope is stable',
				'run diff summary, build output summary, validation evidence collation, and prior-learning alignment in parallel once inputs are stable',
				'run lesson-candidate extraction and overlap search in parallel when they are independent',
				'## `gp-compound-refresh`',
				'run independent track scans or doc reviews in parallel when the evidence sources do not overlap'
			)
		},
		@{
			Path = 'commands/gp-intake.md'
			Needles = @(
				'prefer parallel delegation for independent support tasks'
			)
		},
		@{
			Path = 'commands/gp-debug.md'
			Needles = @(
				'prefer parallel delegation for independent tasks'
			)
		},
		@{
			Path = 'commands/gp-review.md'
			Needles = @(
				'prefer running independent support work such as draft review, evidence collation, and prior-learning alignment in parallel whenever they are independent'
			)
		},
		@{
			Path = 'commands/gp-svn-handoff.md'
			Needles = @(
				'prefer parallel delegation for independent support work such as diff summary, build-output summary, validation-evidence collation, and prior-learning alignment'
			)
		},
		@{
			Path = 'commands/gp-compound.md'
			Needles = @(
				'prefer parallel support work rather than serializing them by default'
			)
		},
		@{
			Path = 'commands/gp-compound-refresh.md'
			Needles = @(
				'prefer parallel review work and combine the accepted conclusions only at the main-agent decision point'
			)
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($needle in $check.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($check.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'task stage runtime contract stays host-project scoped and durable' {
	$checks = @(
		@{
			Path = 'agents/gameplay-main.md'
			Needles = @(
				'docs/cmg/tasks/',
				'03-plan.md',
				'04-progress.md',
				'Performance impact',
				'Performance notes',
				'review-only task directory',
				'review.md',
				'06-handoff.md'
			)
		},
		@{
			Path = 'skills/writing-plans/SKILL.md'
			Needles = @(
				'Performance impact consideration',
				'Do not invent arbitrary performance targets',
				'If there is no meaningful performance concern, state that explicitly'
			)
		},
		@{
			Path = 'skills/gp-task-stage-discipline/SKILL.md'
			Needles = @(
				'docs/cmg/tasks/',
				'YYYY-MM-DD-<task-slug>',
				'Create a new dated task directory when intake is starting a new task instance.',
				'Reuse the active task directory when later stages are continuing the same task.',
				'00-context.md',
				'01-pre-plan.md',
				'02-debug.md',
				'03-plan.md',
				'04-progress.md',
				'05-review.md',
				'review.md',
				'review-only task directory',
				'review scope coverage',
				'06-handoff.md',
				'performance impact consideration',
				'Performance notes',
				'corrected mistakes and their verified fixes',
				'Corrected pitfalls from this task',
				'Transferable lesson candidates from this task',
				'No `03-plan.md` -> no code edits',
				'No performance impact consideration in `03-plan.md` -> no code edits',
				'After context compression, session restart, or agent handoff:'
			)
		},
		@{
			Path = 'skills/lightweight-change-flow/SKILL.md'
			Needles = @(
				'03-plan.md',
				'04-progress.md',
				'Performance impact',
				'Performance notes',
				'fresh compile step'
			)
		},
		@{
			Path = 'skills/standard-feature-flow/SKILL.md'
			Needles = @(
				'03-plan.md',
				'04-progress.md',
				'Performance impact',
				'Performance notes',
				'fresh compile step'
			)
		},
		@{
			Path = 'skills/systematic-debugging/SKILL.md'
			Needles = @(
				'Performance impact'
			)
		},
		@{
			Path = 'skills/gp-subagent-orchestration/references/delegation-matrix.md'
			Needles = @(
				'draft performance impact notes'
			)
		},
		@{
			Path = 'skills/gp-task-stage-discipline/references/task-stage-templates.md'
			Needles = @(
				'Performance impact:',
				'Performance notes:',
				'Independent Review',
				'Validation gaps:',
				'Review scope coverage:',
				'Main-agent accepted review conclusion:'
			)
		},
		@{
			Path = 'docs/workflow/request-lifecycle.md'
			Needles = @(
				'docs/cmg/tasks/YYYY-MM-DD-<task-slug>/',
				'review scope coverage',
				'03-plan.md',
				'04-progress.md',
				'review.md',
				'Performance impact',
				'Performance notes',
				'06-handoff.md'
			)
		},
		@{
			Path = 'docs/operator/quickstart.md'
			Needles = @(
				'Performance impact',
				'Performance notes',
				'review.md'
			)
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($needle in $check.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($check.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'offline package excludes retired untracked runtime files' {
	Add-Type -AssemblyName System.IO.Compression.FileSystem

	$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('cppgamedev-package-proof-' + [guid]::NewGuid().ToString('N'))
	$packageRepo = Join-Path $tempRoot 'repo'

	try {
		New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

		$copyPaths = @(
			'.git',
			'.claude-plugin',
			'agents',
			'commands',
			'skills',
			'docs',
			'scripts',
			'QuickStart.md',
			'README.md',
			'settings.json'
		)

		foreach ($relativePath in $copyPaths) {
			$source = Join-Path $repoRoot $relativePath
			$destination = Join-Path $packageRepo $relativePath
			$parent = Split-Path -Path $destination -Parent
			New-Item -ItemType Directory -Force -Path $parent | Out-Null
			Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
		}

		$staleCommand = Join-Path $packageRepo 'commands\intake.md'
		[System.IO.File]::WriteAllText($staleCommand, "# stale command`n")
		$scratchCommand = Join-Path $packageRepo 'commands\scratch-not-for-release.md'
		[System.IO.File]::WriteAllText($scratchCommand, "# scratch command`n")

		$packageScript = Join-Path $packageRepo 'scripts\package-plugin.bat'
		& $packageScript | Out-Null
		if ($LASTEXITCODE -ne 0) {
			throw 'package-plugin.bat failed in temporary repository copy'
		}

		$zipPath = Get-ChildItem -LiteralPath (Join-Path $packageRepo 'dist') -Filter '*.zip' |
			Sort-Object LastWriteTime -Descending |
			Select-Object -First 1 -ExpandProperty FullName
		Assert-Condition (-not [string]::IsNullOrWhiteSpace($zipPath)) 'package-plugin.bat did not produce a zip artifact'

		$zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
		try {
			$entryNames = @(
				$zip.Entries |
					ForEach-Object { $_.FullName.Replace('\', '/') }
			)
			Assert-Condition ($entryNames -contains 'QuickStart.md') 'packaged zip is missing QuickStart.md'
			Assert-Condition ($entryNames -contains 'agents/code-reviewer.md') 'packaged zip is missing agents/code-reviewer.md'
			Assert-Condition ($entryNames -contains 'agents/gp-experience-researcher.md') 'packaged zip is missing agents/gp-experience-researcher.md'
			Assert-Condition ($entryNames -contains 'commands/gp-intake.md') 'packaged zip is missing commands/gp-intake.md'
			Assert-Condition ($entryNames -contains 'commands/gp-design-parser.md') 'packaged zip is missing commands/gp-design-parser.md'
			Assert-Condition ($entryNames -contains 'skills/gp-experience-researcher/SKILL.md') 'packaged zip is missing skills/gp-experience-researcher/SKILL.md'
			Assert-Condition ($entryNames -contains 'skills/gp-design-parser/SKILL.md') 'packaged zip is missing skills/gp-design-parser/SKILL.md'
			Assert-Condition ($entryNames -contains 'skills/gp-design-parser/implementation-doc-template.md') 'packaged zip is missing skills/gp-design-parser/implementation-doc-template.md'
			Assert-Condition ($entryNames -contains 'skills/gp-design-parser/bin/pdf-to-annotated-markdown.exe') 'packaged zip is missing skills/gp-design-parser/bin/pdf-to-annotated-markdown.exe'
			Assert-Condition (-not ($entryNames -contains 'agents/checklist-reviewer.md')) 'packaged zip must not include retired agents/checklist-reviewer.md'
			Assert-Condition (-not ($entryNames -contains 'agents/cpp-reviewer.md')) 'packaged zip must not include retired agents/cpp-reviewer.md'
			Assert-Condition (-not ($entryNames -contains 'agents/gameplay-reviewer.md')) 'packaged zip must not include retired agents/gameplay-reviewer.md'
			Assert-Condition (-not ($entryNames -contains 'skills/gp-review-checklist/SKILL.md')) 'packaged zip must not include retired skills/gp-review-checklist/SKILL.md'
			Assert-Condition (-not ($entryNames -contains 'skills/gp-review-checklist/references/code-review-checklist.md')) 'packaged zip must not include retired skills/gp-review-checklist/references/code-review-checklist.md'
			Assert-Condition (-not ($entryNames -contains 'skills/gp-design-parser/build-pdf-tool.ps1')) 'packaged zip must not include skills/gp-design-parser/build-pdf-tool.ps1'
			Assert-Condition (-not ($entryNames -contains 'skills/gp-design-parser/pdf_to_annotated_markdown.py')) 'packaged zip must not include skills/gp-design-parser/pdf_to_annotated_markdown.py'
			Assert-Condition (-not ($entryNames -contains 'commands/intake.md')) 'packaged zip must not include stale commands/intake.md'
			Assert-Condition (-not ($entryNames -contains 'commands/scratch-not-for-release.md')) 'packaged zip must not include commands/scratch-not-for-release.md'
			Assert-Condition (-not ($entryNames -contains 'commands/svn-handoff.md')) 'packaged zip must not include stale commands/svn-handoff.md'
			Assert-Condition (-not ($entryNames -contains 'README.md')) 'packaged zip must not include README.md'
		} finally {
			$zip.Dispose()
		}
	} finally {
		Remove-DirectoryIfPresent -Path $tempRoot
	}
}

Invoke-ToolkitCheck 'offline package fails when a tracked runtime source is missing' {
	$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('cppgamedev-package-missing-' + [guid]::NewGuid().ToString('N'))
	$packageRepo = Join-Path $tempRoot 'repo'

	try {
		New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

		$copyPaths = @(
			'.git',
			'.claude-plugin',
			'agents',
			'commands',
			'skills',
			'docs',
			'scripts',
			'QuickStart.md',
			'README.md',
			'settings.json'
		)

		foreach ($relativePath in $copyPaths) {
			$source = Join-Path $repoRoot $relativePath
			$destination = Join-Path $packageRepo $relativePath
			$parent = Split-Path -Path $destination -Parent
			New-Item -ItemType Directory -Force -Path $parent | Out-Null
			Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
		}

		Remove-Item -LiteralPath (Join-Path $packageRepo 'commands\gp-review.md') -Force

		$packageScript = Join-Path $packageRepo 'scripts\package-plugin.bat'
		& $packageScript | Out-Null
		Assert-Condition ($LASTEXITCODE -ne 0) 'package-plugin.bat should fail when a tracked runtime source is missing'
	} finally {
		Remove-DirectoryIfPresent -Path $tempRoot
	}
}

Invoke-ToolkitCheck 'command docs align with plugin runtime authorities' {
	$commandChecks = @(
		@{
			Path = 'commands/gp-intake.md'
			Needles = @('gp-task-stage-discipline', 'gameplay-context-guard', 'task-intake-router', '00-context.md', '01-pre-plan.md', 'pre-plan', 'gp-experience-researcher', 'Experience summary')
		},
		@{
			Path = 'commands/gp-debug.md'
			Needles = @('gp-task-stage-discipline', 'gameplay-context-guard', 'task-intake-router', 'debugging-plan', 'systematic-debugging', 'gp-experience-researcher', 'candidate leads, not proof', '02-debug.md', '03-plan.md')
		},
		@{
			Path = 'commands/gp-review.md'
			Needles = @('gp-task-stage-discipline', 'code-reviewer', 'gp-experience-researcher', 'Relevant prior learnings', 'Review scope coverage', '05-review.md', 'Independent Review', 'review-only directory', 'review.md', 'Do not mechanically require', 'Independent review may report findings without fresh compile or validation evidence', 'Validation gaps')
		},
		@{
			Path = 'commands/gp-svn-handoff.md'
			Needles = @('gp-task-stage-discipline', 'svn-workspace-discipline', 'svn-delivery-handoff', 'fresh successful compile', 'gp-experience-researcher', 'merits `gp-compound`', '06-handoff.md', 'corrected pitfalls', 'transferable lesson candidates')
		},
		@{
			Path = 'commands/gp-compound.md'
			Needles = @('gp-compound', 'host project', 'evidence', 'conclusion', 'validation', '05-review.md', '06-handoff.md')
		},
		@{
			Path = 'commands/gp-compound-refresh.md'
			Needles = @('gp-compound-refresh', 'host project', 'keep', 'update', 'consolidate', 'delete')
		},
		@{
			Path = 'commands/gp-design-parser.md'
			Needles = @('gp-design-parser', '$ARGUMENTS', 'standalone', 'do not route it through `gp-intake`', 'installed_plugins.json', 'installPath', 'implementation-doc-template.md', 'pdf-to-annotated-markdown.exe')
		}
	)

	$missing = @()
	foreach ($commandCheck in $commandChecks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $commandCheck.Path)
		foreach ($needle in $commandCheck.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($commandCheck.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'gp-design-parser annotated output and deletion-line contract stay explicit' {
	$skillText = Get-FileText -Path (Join-Path $repoRoot 'skills/gp-design-parser/SKILL.md')
	$templateText = Get-FileText -Path (Join-Path $repoRoot 'skills/gp-design-parser/implementation-doc-template.md')

	$requiredSkillNeedles = @(
		'<原文件名>-annotated.md',
		'<del>...</del>',
		'标签内文字表示原文删除线，即被划除的旧内容',
		'不要仅因存在 `<del>` 就绕过版本色标和版本记录判断',
		'删除线旧内容若对应既有实现',
		'未制作草案则可以忽略'
	)
	$requiredTemplateNeedles = @(
		'删除线索'
	)

	$missing = @()
	foreach ($needle in $requiredSkillNeedles) {
		if ($skillText -notmatch [regex]::Escape($needle)) {
			$missing += "skills/gp-design-parser/SKILL.md missing $needle"
		}
	}
	foreach ($needle in $requiredTemplateNeedles) {
		if ($templateText -notmatch [regex]::Escape($needle)) {
			$missing += "skills/gp-design-parser/implementation-doc-template.md missing $needle"
		}
	}
	if ($skillText -match [regex]::Escape('<原文件名>-颜色标注.md')) {
		$missing += 'skills/gp-design-parser/SKILL.md must not use the retired <原文件名>-颜色标注.md output name'
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'gp-review uses remaining review support only' {
	$reviewCommandPath = Join-Path $repoRoot 'commands/gp-review.md'
	$text = Get-FileText -Path $reviewCommandPath

	Assert-Condition ($text -match [regex]::Escape('`code-reviewer` agent')) 'commands/gp-review.md must reference the code-reviewer agent by name'
	Assert-Condition ($text -match [regex]::Escape('Review scope coverage')) 'commands/gp-review.md must record review scope coverage'
	Assert-Condition ($text -match [regex]::Escape('main agent decide which findings are accepted and severity-ranked')) 'commands/gp-review.md must keep final review judgment with the main agent'
	Assert-Condition ($text -match [regex]::Escape('Write the accepted independent review result to `<task-dir>/review.md`')) 'commands/gp-review.md must write independent reviews to review.md'
	Assert-Condition ($text -match [regex]::Escape('Independent review may report findings without fresh compile or validation evidence')) 'commands/gp-review.md must allow independent review findings without validation evidence'
	Assert-Condition ($text -match [regex]::Escape('must be recorded in `Validation gaps`')) 'commands/gp-review.md must record missing validation evidence in Validation gaps'
	Assert-Condition ($text -match [regex]::Escape('Do not present an independent review as handoff-ready, delivery-ready, or commit-ready.')) 'commands/gp-review.md must keep independent review separate from delivery readiness'
}

Invoke-ToolkitCheck 'read-only specialist agents inherit MCP tools' {
	$agentPaths = @(
		'agents/code-reviewer.md',
		'agents/gp-experience-researcher.md',
		'agents/log-investigator.md'
	)

	$missing = @()
	foreach ($relativePath in $agentPaths) {
		$text = Get-FileText -Path (Join-Path $repoRoot $relativePath)
		if ($text -notmatch [regex]::Escape('disallowedTools: ["Write", "Edit", "Bash"]')) {
			$missing += "$relativePath must deny Write/Edit/Bash while inheriting MCP tools"
		}
		if ($text -match '(?m)^tools:') {
			$missing += "$relativePath must not use a tools allowlist that hides MCP tools"
		}
		if ($text -notmatch [regex]::Escape('Prefer MCP tools supplied by the active Claude Code session')) {
			$missing += "$relativePath must prefer inherited MCP tools when file tools are blocked"
		}
		if ($text -notmatch [regex]::Escape('do not retry it repeatedly')) {
			$missing += "$relativePath must avoid retry loops when read/search tools are blocked"
		}
	}

	$buildResolverText = Get-FileText -Path (Join-Path $repoRoot 'agents/cpp-build-resolver.md')
	Assert-Condition ($buildResolverText -match [regex]::Escape('tools: ["Read", "Write", "Edit", "Bash", "Grep", "Glob"]')) 'agents/cpp-build-resolver.md keeps build-fix tools explicitly'
	Assert-Condition ($buildResolverText -match [regex]::Escape('Prefer MCP tools supplied by the active Claude Code session')) 'agents/cpp-build-resolver.md must prefer inherited MCP evidence when file tools are blocked'
	Assert-Condition ($buildResolverText -match [regex]::Escape('do not retry it repeatedly')) 'agents/cpp-build-resolver.md must avoid retry loops when read/search tools are blocked'

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'runtime prompts avoid plugin-relative lookup paths' {
	$checks = @(
		@{
			Path = 'commands/gp-review.md'
			Forbidden = @(
				'agents/cpp-reviewer.md',
				'agents/gameplay-reviewer.md',
				'agents/checklist-reviewer.md',
				'skills/gp-review-checklist/references/code-review-checklist.md'
			)
		},
		@{
			Path = 'commands/gp-design-parser.md'
			Forbidden = @(
				'skills/gp-design-parser/SKILL.md',
				'skills/gp-design-parser/build-pdf-tool.ps1',
				'skills/gp-design-parser/pdf_to_annotated_markdown.py'
			)
		},
		@{
			Path = 'agents/gp-experience-researcher.md'
			Forbidden = @(
				'skills/gp-experience-researcher/SKILL.md'
			)
		},
		@{
			Path = 'agents/code-reviewer.md'
			Forbidden = @(
				'agents/gameplay-main.md'
			)
		}
	)

	$hits = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($forbidden in $check.Forbidden) {
			if ($text -match [regex]::Escape($forbidden)) {
				$hits += "$($check.Path) still contains $forbidden"
			}
		}
	}

	Assert-Condition ($hits.Count -eq 0) ($hits -join '; ')
}

Invoke-ToolkitCheck 'specialist agents stay advisory under main-agent orchestration' {
	$checks = @(
		@{
			Path = 'agents/code-reviewer.md'
			Needles = @('candidate', 'draft summary for the main agent', 'Do not issue the final workflow ruling.')
		},
		@{
			Path = 'agents/gp-experience-researcher.md'
			Needles = @('candidate connections', 'draft summary for the main agent', 'Do not make a final ruling.')
		},
		@{
			Path = 'agents/log-investigator.md'
			Needles = @('candidate conclusions', 'draft summary for the main agent', 'Do not issue the final root-cause ruling.')
		},
		@{
			Path = 'agents/cpp-build-resolver.md'
			Needles = @('candidate fix conclusions', 'draft summary for the main agent', 'Do not claim the build is finally resolved.')
		}
	)

	$missing = @()
	foreach ($check in $checks) {
		$text = Get-FileText -Path (Join-Path $repoRoot $check.Path)
		foreach ($needle in $check.Needles) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($check.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'experience fixtures stay in host-project-shaped test paths only' {
	$rootExperiencePath = Join-Path $repoRoot 'docs\cmg'
	Assert-Condition (-not (Test-Path -LiteralPath $rootExperiencePath)) 'Plugin root must not contain runtime host-project experience docs'

	$fixtureFiles = @(
		'tests/fixtures/experience/host-project/docs/cmg/solutions/bugs/combat/buff-remove-ordering-2026-03-30.md',
		'tests/fixtures/experience/host-project/docs/cmg/solutions/patterns/workflow/evidence-before-compound-2026-03-30.md'
	)

	$missing = @()
	foreach ($relativePath in $fixtureFiles) {
		$text = Get-FileText -Path (Join-Path $repoRoot $relativePath)
		if ($text -notmatch '(?m)^---\s*$') {
			$missing += "$relativePath missing frontmatter"
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'router fixtures stay in context-card structure' {
	$requiredFields = @(
		@{ Label = 'Gameplay subdomain'; Pattern = '(?m)^Gameplay subdomain:\s*\S'; },
		@{ Label = 'Main entry point'; Pattern = '(?m)^Main entry point:\s*\S'; },
		@{ Label = 'State and lifecycle impact'; Pattern = '(?m)^State and lifecycle impact:\s*\S'; },
		@{ Label = 'Data and config impact'; Pattern = '(?m)^Data and config impact:\s*\S'; },
		@{ Label = 'Event chain and call path'; Pattern = '(?m)^Event chain and call path:\s*\S'; },
		@{ Label = 'Current evidence source'; Pattern = '(?m)^Current evidence source:\s*\S'; },
		@{ Label = 'Risk level'; Pattern = '(?m)^Risk level:\s*\S'; },
		@{ Label = 'Recommended next path'; Pattern = '(?m)^Recommended next path:\s*\S'; }
	)

	$fixtures = @(
		@{
			Path = 'tests/fixtures/router/lightweight.md'
			ExpectedPlan = 'micro-plan'
			RiskPattern = '(?m)^Risk level:\s*low\s*$'
			ExtraPatterns = @('single-domain', 'low-risk')
		},
		@{
			Path = 'tests/fixtures/router/standard.md'
			ExpectedPlan = 'short-plan'
			RiskPattern = '(?m)^Risk level:\s*medium\s*$'
			ExtraPatterns = @('one gameplay subdomain feature', 'regression risk')
		},
		@{
			Path = 'tests/fixtures/router/complex.md'
			ExpectedPlan = 'full-plan'
			RiskPattern = '(?m)^Risk level:\s*high\s*$'
			ExtraPatterns = @('cross-module', 'high')
		},
		@{
			Path = 'tests/fixtures/router/debugging.md'
			ExpectedPlan = 'debugging-plan'
			RiskPattern = '(?m)^Risk level:\s*high\s*$'
			ExtraPatterns = @('unknown root cause', 'log-driven')
		}
	)

	$missing = @()
	foreach ($fixture in $fixtures) {
		$fullPath = Join-Path $repoRoot $fixture.Path
		$text = Get-FileText -Path $fullPath

		foreach ($field in $requiredFields) {
			if ($text -notmatch $field.Pattern) {
				$missing += "$($fixture.Path) missing field: $($field.Label)"
			}
		}

		if ($text -notmatch "(?m)^Recommended next path:\s*$([regex]::Escape($fixture.ExpectedPlan))\s*$") {
			$missing += "$($fixture.Path) has wrong recommended next path"
		}

		if ($text -notmatch $fixture.RiskPattern) {
			$missing += "$($fixture.Path) has wrong risk level"
		}

		foreach ($needle in $fixture.ExtraPatterns) {
			if ($text -notmatch [regex]::Escape($needle)) {
				$missing += "$($fixture.Path) missing $needle"
			}
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'cpp coding fixtures cover approved and rejected markers' {
	$approvedPath = Join-Path $repoRoot 'tests/fixtures/cpp-review/approved-sample.cpp'
	$rejectedPath = Join-Path $repoRoot 'tests/fixtures/cpp-review/reject-sample.cpp'

	$approved = Get-FileText -Path $approvedPath
	$rejected = Get-FileText -Path $rejectedPath

	$approvedChecks = @(
		@{ Need = '(?m)^using\s+\w+\s*='; Label = 'using alias' },
		@{ Need = '\bm_'; Label = 'm_ prefix' },
		@{ Need = '\bnullptr\b'; Label = 'nullptr' },
		@{ Need = '\boverride\b'; Label = 'override' },
		@{ Need = '\bfinal\b'; Label = 'final' },
		@{ Need = "`t"; Label = 'tab indentation' }
	)

	$rejectedChecks = @(
		@{ Need = '\bNULL\b'; Label = 'NULL' },
		@{ Need = '\btypedef\b'; Label = 'typedef' },
		@{ Need = '(?m)^.*virtual.*override.*$'; Label = 'virtual override misuse' },
		@{ Need = 'm_pBuffer\s*=\s*buffer'; Label = 'lifetime bug' }
	)

	$missing = @()
	foreach ($check in $approvedChecks) {
		if ($approved -notmatch $check.Need) {
			$missing += "approved-sample.cpp missing $($check.Label)"
		}
	}

	foreach ($check in $rejectedChecks) {
		if ($rejected -notmatch $check.Need) {
			$missing += "reject-sample.cpp missing $($check.Label)"
		}
	}

	Assert-Condition ($missing.Count -eq 0) ($missing -join '; ')
}

Invoke-ToolkitCheck 'claude CLI smoke precheck is documented or manually pending' {
	$quickstartText = Get-FileText -Path (Join-Path $repoRoot 'docs/operator/quickstart.md')
	Assert-Condition ($quickstartText -match [regex]::Escape('claude --plugin-dir I:\CppGameDev')) 'docs/operator/quickstart.md missing plugin smoke-test command'
	Assert-Condition ($quickstartText -match [regex]::Escape('/plugin marketplace add foryoung365/CppGameDev-skill')) 'docs/operator/quickstart.md missing marketplace add command'
	Assert-Condition ($quickstartText -match [regex]::Escape('/plugin install cmg@foryoung365-plugins')) 'docs/operator/quickstart.md missing marketplace install command'

	$claude = Get-Command claude -ErrorAction SilentlyContinue
	if ($null -ne $claude) {
		$versionOutput = & claude --version 2>&1
		Assert-Condition ($LASTEXITCODE -eq 0) 'claude --version failed'
		Assert-Condition (-not [string]::IsNullOrWhiteSpace(($versionOutput | Out-String))) 'claude --version produced no output'
	}
}

$failures = @($script:Results | Where-Object Status -eq 'FAIL')
foreach ($result in $script:Results) {
	if ($result.Status -eq 'PASS') {
		Write-Host "PASS: $($result.Name)"
	} else {
		Write-Host "FAIL: $($result.Name)"
		Write-Host "      $($result.Details)"
	}
}

if ($failures.Count -gt 0) {
	Write-Host ("FAIL: Toolkit verification failed. {0}/{1} checks passed." -f ($script:Results.Count - $failures.Count), $script:Results.Count)
	exit 1
}

Write-Host ("PASS: Toolkit verification passed. {0}/{1} checks passed." -f $script:Results.Count, $script:Results.Count)
exit 0
