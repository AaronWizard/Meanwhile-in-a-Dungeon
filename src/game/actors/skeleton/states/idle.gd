extends ActorState

@export var actor_motion: ActorMotion
@export var deceleration := 12.0

@export var sight_radius := 150
@export var chase_state := &""

@export var attack_radius := 24
@export var attack_state := &"Attack"

var _body: Node2D


func _ready() -> void:
	_body = owner as Node2D


func _process_main(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)

	var target_vector := _vector_to_target()

	if target_vector.length_squared() <= (attack_radius * attack_radius):
		return attack_state
	elif target_vector.length_squared() <= (sight_radius * sight_radius):
		return chase_state

	return &""


func _vector_to_target() -> Vector2:
	var player_pos := Globals.player.position
	var self_pos := _body.position
	return player_pos - self_pos
