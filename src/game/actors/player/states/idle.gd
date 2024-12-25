extends ActorState

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var deceleration := 12.0


func process(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	return player_input.desired_state
