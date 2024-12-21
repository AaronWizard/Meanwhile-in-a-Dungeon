extends ActorState

@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0

@export var sight_radius := 150
@export var idle_state := &"Idle"

@export var attack_pivot: Node2D
@export var attack_radius := 24
@export var attack_state := &"Attack"

var _body: Node2D


func _ready() -> void:
	_body = owner as Node2D


func _process_main(_delta: float) -> StringName:
	var target_vector := _vector_to_target()

	if target_vector.length_squared() <= (attack_radius * attack_radius):
		return attack_state
	if target_vector.length_squared() > (sight_radius * sight_radius):
		return idle_state

	var desired_velocity := target_vector.normalized() * max_speed
	actor_motion.move_velocity_toward(desired_velocity, acceleration)
	return &""


func _vector_to_target() -> Vector2:
	var player_pos := Globals.player.position + attack_pivot.position
	var self_pos := _body.position + attack_pivot.position
	return player_pos - self_pos
