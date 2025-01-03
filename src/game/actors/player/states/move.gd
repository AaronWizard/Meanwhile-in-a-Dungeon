extends ActorState

@export var player_input: PlayerInput
@export var footstep_sounds: FootstepSoundPlayer2D

var time := 0.0

func enter() -> void:
	super()
	footstep_sounds.active = true
	time = 0.0


func exit() -> void:
	footstep_sounds.active = false


func physics_process(delta: float) -> StringName:
	_move_body(player_input.move_vector, delta)
	return player_input.desired_state
