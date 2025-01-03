class_name PlayerInput
extends Node

## Reads the player's input to determine what state a player actor ought to be
## in, corresponding to [State] nodes in a [StateMachine].

## The state for the player actor to stand idle, doing no actions.
const STATE_IDLE := &"Idle"
## The state for player actor to move.
const STATE_MOVE := &"Move"
## The state for the player actor to attack.
const STATE_ATTACK := &"Attack"

const _STATE_PRIORITIES := {
	STATE_IDLE: 0,
	STATE_MOVE: 1,
	STATE_ATTACK: 2
}


## The desired state for the player actor based on current input.
var desired_state: StringName:
	get:
		return _desired_state


## The movement vector for the player actor based on current directional inputs.
var move_vector: Vector2:
	get:
		return _move_vector


var _desired_state := STATE_IDLE
var _move_vector := Vector2.ZERO


func _unhandled_input(_event: InputEvent) -> void:
	var all_desired_states: Array[StringName] = []

	_move_vector = Input.get_vector(
			"move_west", "move_east", "move_north", "move_south")

	if not move_vector.is_zero_approx():
		all_desired_states.append(STATE_MOVE)

	if Input.is_action_pressed("attack"):
		all_desired_states.append(STATE_ATTACK)

	if all_desired_states.is_empty():
		all_desired_states.append(STATE_IDLE)

	all_desired_states.sort_custom(_state_sort)
	_desired_state = all_desired_states[0]


static func _state_sort(a: StringName, b: StringName) -> bool:
	return _STATE_PRIORITIES[a] > _STATE_PRIORITIES[b]
