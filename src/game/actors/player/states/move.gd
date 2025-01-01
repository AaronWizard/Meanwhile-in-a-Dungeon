extends ActorState

@export var player_input: PlayerInput

## In pixels per second
@export var max_speed := 128.0
## In pixels per second squared.
@export var acceleration := 1280

@export var footstep_sounds: FootstepSoundPlayer2D

var time := 0.0

func enter() -> void:
	super()
	footstep_sounds.active = true
	time = 0.0


func exit() -> void:
	footstep_sounds.active = false


func physics_process(delta: float) -> StringName:
	_move_body(
		body.velocity.move_toward(
			player_input.move_vector * max_speed, acceleration * delta
		)
	)
	return player_input.desired_state
