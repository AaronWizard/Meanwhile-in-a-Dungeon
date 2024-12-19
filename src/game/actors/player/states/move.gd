extends ActorState

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var acceleration := 10.0
@export var max_speed := 128.0


func _process_main(_delta: float) -> StringName:
	var desired_velocity := player_input.move_vector * max_speed
	actor_motion.move_velocity_toward(desired_velocity, acceleration)
	return player_input.desired_state
