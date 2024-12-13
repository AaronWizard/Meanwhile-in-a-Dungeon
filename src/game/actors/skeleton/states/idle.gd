extends State

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation


func enter() -> void:
	_motion_direction_animation.active = true


func exit() -> void:
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	return &""


func physics_process(_delta: float) -> StringName:
	return &""
