extends ActorState

@export var player_input: PlayerInput

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation


func enter() -> void:
	_motion_direction_animation.active = true


func exit() -> void:
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	return player_input.desired_state
