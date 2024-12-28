class_name StrafeAroundEnemyBehaviour
extends SteeringBehaviour

@export var body: Node2D
@export var motion: ActorMotion


func _fill_context_map(context_map: SteeringContextMap, _delta: float) -> void:
	var target_vector := _get_vector_to_target().normalized()

	var left := target_vector.rotated(PI / 2.0)
	var left_dot := left.dot(motion.velocity.normalized())

	var right := target_vector.rotated(PI / -2.0)
	var right_dot := right.dot(motion.velocity.normalized())

	var left_bias := 1.0
	var right_bias := 1.0

	if left_dot > right_dot:
		right_bias /= 2
	else:
		left_bias /= 2

	context_map.assign_interest_vector(left * left_bias)
	context_map.assign_interest_vector(right * right_bias)


func _get_vector_to_target() -> Vector2:
	var target_pos := Globals.player.global_position
	var self_pos := body.global_position
	return target_pos - self_pos
