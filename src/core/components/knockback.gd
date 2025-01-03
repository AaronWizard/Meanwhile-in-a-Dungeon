@tool
class_name Knockback
extends Node

signal finished

@export_group("Motion")
## In pixels.
@export var distance := 48.0
## In seconds.
@export var time := 0.2667

@export_group("Actor")


@export var hurtbox: Hurtbox:
	set(value):
		hurtbox = value
		update_configuration_warnings()


@export var state_machine: StateMachine
@export var return_state := &"Idle"

@export_group("Animation")
@export var direction_animation_player: DirectionAnimationPlayer
@export var flying_anim_set := &""
@export var stop_anim_set := &""


var is_flying_back: bool:
	get:
		return not _current_velocity.is_zero_approx()


var _initial_speed := 0.0
var _decelleration := 0.0

var _current_velocity := Vector2.ZERO

var _state_machine_was_running := false

@onready var _body := owner as CharacterBody2D


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	if owner is not CharacterBody2D:
		result.append("Needs to be a child of a CharacterBody2D")

	if not hurtbox:
		result.append("Need a Hurtbox")

	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if not _body:
		push_error("'%s' is not a child of a CharacterBody2D" % name)

	hurtbox.was_hit.connect(_was_hit)

	# Formula for initial velocity is:
	#
	# velocity_initial = ((distance * 2.0) / time) - velocity_final
	#
	# And final velocity is zero.
	_initial_speed = (distance * 2.0) / time

	# Formula for acceleration is:
	#
	# acceleration = ((velocity_final - (distance / time)) * 2.0) / time
	#
	# And final velocity is zero.
	# Also, ActorMotion.accelerate_to_target_velocity takes positive values for
	# decelleration.
	_decelleration = (distance * 2.0) / (time * time)


func _process(delta: float) -> void:
	if Engine.is_editor_hint() or _current_velocity.is_zero_approx() \
			or not _body:
		return

	_body.velocity = _current_velocity
	_body.move_and_slide()

	_current_velocity = _current_velocity.move_toward(
			Vector2.ZERO, _decelleration * delta)
	if _current_velocity.is_zero_approx():
		_stop_knockback()


func _was_hit(_damage: int, direction: Vector2) -> void:
	if state_machine:
		_state_machine_was_running = state_machine.running
		if _state_machine_was_running:
			state_machine.running = false

	if direction_animation_player and not flying_anim_set.is_empty():
		direction_animation_player.direction = direction
		direction_animation_player.set_animation_set(flying_anim_set)

	hurtbox.invincible = true
	_current_velocity = direction * _initial_speed


func _stop_knockback() -> void:
	_current_velocity = Vector2.ZERO
	hurtbox.invincible = false

	if direction_animation_player and not stop_anim_set.is_empty():
		direction_animation_player.direction *= -1
		direction_animation_player.set_animation_set(stop_anim_set)

	if state_machine and _state_machine_was_running:
		state_machine.running = true
		state_machine.switch_state(return_state)

	finished.emit()
