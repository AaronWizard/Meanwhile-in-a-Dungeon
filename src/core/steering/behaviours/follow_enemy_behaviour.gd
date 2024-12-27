class_name FollowEnemyBehaviour
extends SteeringBehaviour

## Follows an enemy at a certain range.

## Radius to follow target at. In pixels.
@export var follow_radius := 0.0

## Distance to start slowing down when reaching desired range. In pixels.
@export var slow_distance := 100.0

@export var body: Node2D


func _fill_context_map(context_map: SteeringContextMap, _delta: float) -> void:
	var target_vector := _get_vector_to_target()
	var direction := target_vector.normalized()
	var distance := target_vector.length()

	if distance < follow_radius:
		# Want to get way. The closer we are the faster we want to move.
		var diff := (follow_radius - distance) / follow_radius
		context_map.assign_interest_vector(-direction * diff)
	else:
		# Want to approach. The farther we are the faster we want to move.
		var diff := minf((distance - follow_radius) / slow_distance, 1.0)
		context_map.assign_interest_vector(direction * diff)


func _get_vector_to_target() -> Vector2:
	var target_pos := Globals.player.global_position
	var self_pos := body.global_position
	return target_pos - self_pos
