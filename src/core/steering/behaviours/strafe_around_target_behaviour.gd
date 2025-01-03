class_name StrafeAroundTargetBehaviour
extends SteeringBehaviour

@export var target_global_pos := Vector2.ZERO
@export var strafe_scale := 0.0
@export var body: CharacterBody2D


func _fill_context_map(context_map: SteeringContextMap, _delta: float) -> void:
	var target_vector := _target_vector().normalized()

	var left := Vector2(-target_vector.y, target_vector.x)
	var right := Vector2(target_vector.y, -target_vector.x)

	var strafe_vector := Vector2.ZERO
	if not is_zero_approx(strafe_scale):
		if strafe_scale < 0:
			strafe_vector = left * absf(strafe_scale)
		elif strafe_scale > 0:
			strafe_vector = right * strafe_scale

	context_map.assign_interest_vector(strafe_vector)


func _target_vector() -> Vector2:
	return target_global_pos - body.global_position
