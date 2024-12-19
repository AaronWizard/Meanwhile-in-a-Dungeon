extends ActorState

@export var deceleration := 12.0

@export var sight_radius := 150
@export var chase_state := &""

@export var actor_motion: ActorMotion

var _body: Node2D


func _ready() -> void:
	_body = owner as Node2D


func _process_main(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)

	var player_pos := Globals.player.position
	var self_pos := _body.position
	var distance_sqrd := (player_pos - self_pos).length_squared()
	if distance_sqrd <= (sight_radius * sight_radius):
		return chase_state

	return &""
