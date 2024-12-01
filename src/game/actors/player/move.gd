extends State


@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var max_speed := 100.0

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation


func enter() -> void:
	_motion_direction_animation.active = true


func exit() -> void:
	actor_motion.velocity = Vector2.ZERO
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	actor_motion.velocity = player_input.move_vector * max_speed
	return player_input.desired_state
