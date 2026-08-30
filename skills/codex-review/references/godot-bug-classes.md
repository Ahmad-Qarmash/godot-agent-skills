# Godot & game bug classes

Append this to the review prompt when the repo is a Godot project (`project.godot` present).
These are the breakage patterns a generic code review misses because they fail at runtime, in
the editor, or three scenes away from the diff. Hunt them specifically.

## Scene & resource files (`.tscn` / `.tres`)

- A `[connection]` block targeting a method renamed or removed in the script — the scene parses
  and loads fine; the error appears only when the signal fires.
- Node renamed or reparented while `$Node/Path`, `get_node()`, an exported `NodePath`, a tween's
  target, or an AnimationPlayer/AnimationTree track path still references the old path.
- `load_steps` not matching the actual resource count after a hand edit; duplicated or dangling
  `ext_resource` / `sub_resource` ids; a `uid://` still pointing at a moved or re-imported file.
- `script = ExtResource(...)` pointing at a script whose path or `class_name` changed.
- Inherited scenes: a property override in the child scene silently masking a change made to the
  base scene — the base edit "does nothing" and nobody knows why.
- A SubResource or `.tres` shared where a unique copy was intended (`resource_local_to_scene`
  absent, or `.duplicate()` missing) — tweaking one instance's resource tweaks every instance.

## Lifecycle & node access

- `@onready` state touched before `_ready()` runs — from `_init()`, a setter executing at load,
  or a parent that assumes children are ready before its own `_ready()` (children ready first;
  code assuming the opposite direction for setup/injection).
- Use-after-free: node accessed after `queue_free()` without `is_instance_valid()`; an `await`
  resuming after its owner left the tree; a lambda capturing a node that dies before the signal.
- `connect()` on a code path that re-runs (scene re-entered, node re-added) without a guard or
  `CONNECT_ONE_SHOT` — duplicate connections, handlers firing twice, damage applied twice.
- A signal's argument list changed while some connected callback — especially one wired in a
  `.tscn` — kept the old signature.
- `_exit_tree` / `NOTIFICATION_PREDELETE` cleanup missing for something registered globally
  (an autoload list, a static array, a custom event bus) — dead references accumulate.

## Frame, physics & input

- Frame-rate dependence: movement, cooldowns, or accumulation scaled per-frame instead of by
  `delta`; `lerp(a, b, 0.1)` each frame without delta-correct smoothing — the game plays
  differently at 30 vs 144 FPS.
- Logic moved between `_process` and `_physics_process` without re-checking which delta it uses
  and where its input is sampled; `Input.is_action_just_pressed()` polled in
  `_physics_process` (missed or doubled on frame-rate mismatch).
- A RigidBody positioned by writing its transform instead of impulses/`_integrate_forces` —
  physics fights the assignment intermittently.
- Collision layer/mask changed on one side of an interaction but not the other — the pair
  silently stops colliding; `body_entered` vs `area_entered` mixed up; monitoring/monitorable
  toggled off and never restored.
- An input event consumed early (`set_input_as_handled`, a Control swallowing focus) starving
  `_unhandled_input` consumers added in this diff.

## State, determinism & saves

- An autoload holding run state that is never reset on scene reload — works on the first run,
  breaks on retry/restart. The classic "works in the demo, breaks on death."
- Autoload renamed or reordered in `project.godot` with stale references or an ordering
  dependency between autoloads' `_ready()` calls.
- RNG: `randomize()` added or removed changing determinism; one shared RNG where an extra call
  in system A desyncs system B; seeded runs (daily challenge, replays, lockstep) polluted by an
  unseeded call.
- A save/`.tres` shape change with no migration path — old saves load with silent defaults or
  fail. Flag loudly: shipped players carry old saves that cannot be force-updated.
- `@export` var renamed or retyped — values already serialized in scenes and resources are
  silently dropped to defaults across the project, not just in the diffed files.
- Writes to `res://` (read-only in exported builds) instead of `user://`.

## Game math & feel

- Radians vs degrees: `rotation` is radians; mixing it with `rotation_degrees` or hand-rolled
  degree math.
- 2D y-axis points down: "up" impulses with positive y, gravity or jump signs flipped.
- Local vs global space: `position` where `global_position` is required after reparenting;
  directions not transformed by the node's basis/rotation.
- Grid/tile math: off-by-one at boundaries, world↔map conversions using the wrong cell size or
  layer, `floor()` vs `int()` for negative coordinates.
- Integer division truncation (`3 / 2 == 1`) inside damage, cost, or progression formulas —
  flag any `int / int` in a tuned formula.

## Godot 3 ghosts

If the diff contains Godot 3 API (`instance()`, `yield(...)`, bare `onready var`,
`KinematicBody*`, `move_and_slide(velocity)` with arguments, `export(...)` syntax), report it
as `correctness`, not style — some of it parses in 4 and misbehaves instead of erroring. The
repo's `godot4-api-guard` skill tables are the reference if installed.
