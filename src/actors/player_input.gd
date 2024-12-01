class_name PlayerInput
extends Node

const STATE_IDLE := &"Idle"
const STATE_MOVE := &"Move"
const STATE_ATTACK := &"Attack"


const STATE_PRIORITIES := {
	STATE_IDLE: 0,
	STATE_MOVE: 1,
	STATE_ATTACK: 2
}


var desired_state: StringName:
	get:
		return _desired_state


var move_vector: Vector2:
	get:
		return _move_vector


var is_moving:
	get:
		return move_vector.length_squared() > 0


var _desired_state := STATE_IDLE
var _move_vector := Vector2.ZERO


func _unhandled_input(_event: InputEvent) -> void:
	var all_desired_states: Array[StringName] = []

	_move_vector = Input.get_vector(
			"move_west", "move_east", "move_north", "move_south")

	if is_moving:
		all_desired_states.append(STATE_MOVE)

	if Input.is_action_pressed("attack"):
		all_desired_states.append(STATE_ATTACK)

	if all_desired_states.is_empty():
		all_desired_states.append(STATE_IDLE)

	all_desired_states.sort_custom(_state_sort)
	_desired_state = all_desired_states[0]


static func _state_sort(a: StringName, b: StringName) -> bool:
	return STATE_PRIORITIES[a] > STATE_PRIORITIES[b]
