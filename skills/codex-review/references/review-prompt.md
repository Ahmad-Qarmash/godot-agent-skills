# Code review

Follow the `## Review task` appended to this prompt. Read the surrounding code, `CLAUDE.md` /
`AGENTS.md`, `project.godot`, and relevant repository documentation as needed to verify each
finding.

This is a Godot project. Scene and resource files are code — review them with the same
seriousness as scripts:

- `.tscn` / `.tres` diffs: check `load_steps` against the actual resource count, dangling or
  duplicated `ext_resource` / `sub_resource` ids, `uid://` references, `[connection]` blocks
  whose target method no longer exists or whose signature no longer matches, and node renames
  that orphan `NodePath`s, `$Node/Path` accesses, exported NodePaths, or AnimationPlayer
  track paths elsewhere in the diff or repo.
- GDScript: prefer runtime-failure reasoning over style. Godot errors surface when a signal
  fires or a node path resolves, not at parse time — "it parses" proves nothing. Trace what
  happens at emit time, at `_ready()` time, and after `queue_free()`.
- Gameplay code: check frame-rate independence (`delta` usage), coordinate spaces
  (local vs global, y-down in 2D), radians vs degrees, and integer division in tuned formulas.

Report only concrete issues that warrant a change; omit cosmetic nitpicks. Assess architecture,
structure, conventions, and code quality, and call out concerns that materially harm
maintainability. Categorize architectural disagreements as `architecture` and present them as
tradeoffs rather than defects. Return a clean verdict with an empty findings array when nothing
warrants changing.

Do not modify files. State each failure concretely and respond only with the JSON object
required by the output schema.
