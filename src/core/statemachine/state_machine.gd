@tool
class_name StateMachine
extends Node

## A state machine.
##
## A state machine node with child [State] nodes. The initial state is the first
## child node.

var _current_state: State


func _get_configuration_warnings() -> PackedStringArray:
	var result: PackedStringArray = []

	if get_child_count() == 0:
		result.append("No child states")

	for c in get_children():
		if c is not State:
			result.append("'%s' is not an State" % c.name)

	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if get_child_count() == 0:
		push_error("No initial state")
		return
	if get_child(0) is not State:
		push_error("'%s' is not an State" % get_child(0).name)
		return

	_current_state = get_child(0) as State
	_current_state.enter()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not _current_state:
		push_error("No current state")
		return

	var next_state_name := _current_state.process(delta)
	_try_switch_state(next_state_name)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not _current_state:
		push_error("No current state")
		return

	var next_state_name := _current_state.physics_process(delta)
	_try_switch_state(next_state_name)


## Switches the current state to the child state node whose name is
## [param next_state_name].
func switch_state(next_state_name: StringName) -> void:
	var next_state := get_node(NodePath(next_state_name)) as State
	if not next_state:
		push_error("'%s' is not an State" % next_state_name)
		return
	if next_state not in get_children():
		push_error("'%s' is not a child state" % next_state_name)
		return
	if next_state == _current_state:
		push_warning("'%s' is already the current state" % next_state_name)

	_current_state.exit()
	_current_state = next_state
	_current_state.enter()


func _try_switch_state(next_state_name: StringName) -> void:
	if not next_state_name.is_empty() \
			and (next_state_name != _current_state.name):
		switch_state(next_state_name)