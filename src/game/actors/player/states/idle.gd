extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var deceleration := 12.0

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation


func enter() -> void:
	_motion_direction_animation.active = true


func exit() -> void:
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	return player_input.desired_state
