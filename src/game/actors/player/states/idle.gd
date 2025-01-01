extends ActorState

@export var player_input: PlayerInput

## In pixels per second squared.
@export var deceleration := 1280.0


func physics_process(delta: float) -> StringName:
	_move_body(
		body.velocity.move_toward(Vector2.ZERO, deceleration * delta)
	)
	return player_input.desired_state
