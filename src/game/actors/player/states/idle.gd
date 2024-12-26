extends ActorState

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

## In pixels per second squared.
@export var deceleration := 1280.0


func process(delta: float) -> StringName:
	actor_motion.accelerate_to_target_velocity(
			Vector2.ZERO, deceleration, delta)
	return player_input.desired_state
