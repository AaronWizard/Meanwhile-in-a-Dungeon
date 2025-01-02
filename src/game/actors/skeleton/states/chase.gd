extends ActorState

@export var motion_raycast: MotionRaycast

@export var anim_set_motion := &"move"
@export var anim_set_idle := &"idle"

@onready var _steering_motion := $SteeringMotion as SteeringMotion

@onready var _approach_target \
		:= $SteeringMotion/ApproachTargetBehaviour as ApproachTargetBehaviour
@onready var _strafe := $SteeringMotion/StrafeAroundTargetBehaviour \
		as StrafeAroundTargetBehaviour


func enter() -> void:
	super()
	motion_raycast.enabled = true
	_approach_target.radius = randf_range(32, 64)
	_strafe.strafe_scale = randf_range(-1, 1)


func exit() -> void:
	motion_raycast.enabled = false


func physics_process(delta: float) -> StringName:
	_approach_target.target_global_pos = Globals.player.global_position
	_strafe.target_global_pos = Globals.player.global_position

	var motion_vector := _steering_motion.get_velocity(delta)
	_move_body(motion_vector, delta)

	if body.velocity.is_zero_approx():
		direction_animation_player.set_animation_set(anim_set_idle)
	else:
		direction_animation_player.set_animation_set(anim_set_motion)
	return &""
