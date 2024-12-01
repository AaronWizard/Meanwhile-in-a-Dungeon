extends ActorState

@export var player_input: PlayerInput


func update(_delta: float) -> StringName:
	return player_input.desired_state
