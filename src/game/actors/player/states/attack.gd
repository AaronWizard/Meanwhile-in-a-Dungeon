extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var deceleration := 8.0


@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation

var anim_running := false


func _ready() -> void:
	_motion_direction_animation.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	anim_running = true
	_motion_direction_animation.active = true


func exit() -> void:
	assert(anim_running == false)
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	if not anim_running:
		return player_input.desired_state
	return &""
