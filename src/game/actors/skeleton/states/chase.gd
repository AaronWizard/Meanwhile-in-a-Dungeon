extends ActorState

@export var motion_raycast: MotionRaycast

@export var anim_set_motion := &"move"
@export var anim_set_idle := &"idle"

@export var attack_range: Area2D
@export var attack_state := &"Attack"

@export var attack_timer: Timer

var _in_attack_range := false

@onready var _steering_motion := $SteeringMotion as SteeringMotion

@onready var _approach_target \
		:= $SteeringMotion/FollowTargetBehaviour as FollowTargetBehaviour
@onready var _strafe := $SteeringMotion/StrafeAroundTargetBehaviour \
		as StrafeAroundTargetBehaviour


func _ready() -> void:
	attack_range.monitoring = false
	attack_range.body_entered.connect(_on_attack_range_body_entered)


func enter() -> void:
	super()
	_in_attack_range = false
	attack_range.monitoring = true
	motion_raycast.enabled = true
	#_approach_target.radius = randf_range(32, 64)
	_strafe.strafe_scale = randf_range(-1, 1)


func exit() -> void:
	attack_range.monitoring = false
	motion_raycast.enabled = false
	_in_attack_range = false


func physics_process(delta: float) -> StringName:
	_approach_target.target_global_pos = Globals.player.global_position
	_strafe.target_global_pos = Globals.player.global_position

	var motion_vector := _steering_motion.get_velocity(delta)
	_move_body(motion_vector, delta)

	if body.velocity.is_zero_approx():
		direction_animation_player.set_animation_set(anim_set_idle)
	else:
		direction_animation_player.set_animation_set(anim_set_motion)

	#if _in_attack_range and (not attack_timer or attack_timer.is_stopped()):
		#attack_timer.start()
		#return attack_state

	return &""


func _on_attack_range_body_entered(other: Node2D) -> void:
	if other == Globals.player:
		_in_attack_range = true
