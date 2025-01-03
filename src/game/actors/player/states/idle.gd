extends ActorState

@export var player_input: PlayerInput


func physics_process(delta: float) -> StringName:
	_move_body(Vector2.ZERO, delta)
	return player_input.desired_state
