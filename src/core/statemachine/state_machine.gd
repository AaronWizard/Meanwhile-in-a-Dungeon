@tool
class_name StateMachine
extends Node

## A state machine.
##
## A state machine node with child [State] nodes. The initial state is the first
## child node.

@export var running := true:
	set(value):
		var old_running := running
		running = value

		if not Engine.is_editor_hint() and (old_running != running) \
				and _current_state:
			if running:
				_current_state.enter()
			else:
				_current_state.exit()

			if debug_show_state and (owner is Node2D):
				(owner as Node2D).queue_redraw()


@export var debug_show_state := false

var _current_state: State


var current_state_name: StringName:
	get:
		return _current_state.name


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	if get_child_count() == 0:
		result.append("No child states")

	for c in get_children():
		if c is not State:
			result.append("'%s' is not an State" % c.name)

	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if debug_show_state and (owner is Node2D):
		(owner as Node2D).draw.connect(_debug_draw.bind(owner as Node2D))

	if get_child_count() == 0:
		push_error("No initial state")
		return
	if get_child(0) is not State:
		push_error("'%s' is not an State" % get_child(0).name)
		return

	_current_state = get_child(0) as State

	if running:
		_current_state.enter()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not _current_state:
		push_error("No current state")
		return

	if running:
		var next_state_name := _current_state.process(delta)
		switch_state(next_state_name)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not _current_state:
		push_error("No current state")
		return

	if running:
		var next_state_name := _current_state.physics_process(delta)
		switch_state(next_state_name)


## Switches the current state to the child state node whose name is
## [param next_state_name]. Returns true if the state switch was successful.
func switch_state(next_state_name: StringName) -> bool:
	if not running:
		push_warning("Cannot switch states while state machine is paused")
		return false

	if next_state_name.is_empty() or (next_state_name == _current_state.name):
		return false

	var next_state := get_node(NodePath(next_state_name)) as State
	if not next_state:
		push_error("'%s' is not a State" % next_state_name)
		return false
	if next_state not in get_children():
		push_error("'%s' is not a child state" % next_state_name)
		return false

	_current_state.exit()
	_current_state = next_state
	_current_state.enter()

	if debug_show_state and (owner is Node2D):
		(owner as Node2D).queue_redraw()

	return true


func _debug_draw(target: Node2D) -> void:
	var text := _current_state.name
	if not running:
		text = "<not running>"

	var font := ThemeDB.fallback_font
	var font_size := 8
	var size := font.get_string_size(
			text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)

	target.draw_string(
		font, Vector2(-size.x / 2.0, size.y), text,
		HORIZONTAL_ALIGNMENT_CENTER, -1, font_size
	)
