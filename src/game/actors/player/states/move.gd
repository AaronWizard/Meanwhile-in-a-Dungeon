extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var acceleration := 10.0
@export var max_speed := 128.0

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation


func enter() -> void:
	_motion_direction_animation.active = true


func exit() -> void:
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	var desired_velocity := player_input.move_vector * max_speed
	actor_motion.move_velocity_toward(desired_velocity, acceleration)
	return player_input.desired_state
