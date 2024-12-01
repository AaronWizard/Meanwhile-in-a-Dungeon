extends ActorState

@export var player_input: PlayerInput


func process(_delta: float) -> StringName:
	return player_input.desired_state
