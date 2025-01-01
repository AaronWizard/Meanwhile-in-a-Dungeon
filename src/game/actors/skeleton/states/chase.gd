extends ActorState

@export var motion_raycast: MotionRaycast

@export var anim_set_motion := &"move"
@export var anim_set_idle := &"idle"

## In pixels per second.
@export var max_speed := 100.0
## In pixels per second squared.
@export var acceleration := 1000.0

@onready var _steering_motion := $SteeringMotion as SteeringMotion


func enter() -> void:
	super()
	motion_raycast.enabled = true


func exit() -> void:
	motion_raycast.enabled = false


func physics_process(delta: float) -> StringName:
	var motion_vector := _steering_motion.get_velocity(delta)
	_move_body(
		body.velocity.move_toward(
			motion_vector * max_speed, acceleration * delta
		)
	)

	if body.velocity.is_zero_approx():
		direction_animation_player.set_animation_set(anim_set_idle)
	else:
		direction_animation_player.set_animation_set(anim_set_motion)
	return &""
