extends ActorState

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

## In pixels per second squared.
@export var acceleration := 1280
## In pixels per second
@export var max_speed := 128.0

@export var footstep_sounds: AudioStreamPlayer2D

var time := 0.0

func enter() -> void:
	super()
	footstep_sounds.play()
	time = 0.0


func exit() -> void:
	footstep_sounds.stop()


func process(delta: float) -> StringName:
	time += delta
	var desired_velocity := player_input.move_vector * max_speed
	actor_motion.accelerate_to_target_velocity(
			desired_velocity, acceleration, delta)
	return player_input.desired_state
