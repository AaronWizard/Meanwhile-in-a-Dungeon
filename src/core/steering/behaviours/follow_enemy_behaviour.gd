class_name FollowEnemyBehaviour
extends SteeringBehaviour

## Follows an enemy at a certain range.

## In pixels.
@export var follow_radius := 64.0

@export var body: CharacterBody2D


func _fill_context_map(context_map: SteeringContextMap, _delta: float) -> void:
	var target_vector := _get_vector_to_target()
	var direction := target_vector.normalized()
	var distance := target_vector.length()

	if distance < follow_radius:
		# Want to get way. The closer we are the faster we want to move.
		var diff := (follow_radius - distance) / follow_radius
		context_map.assign_danger_vector(direction * diff)
	else:
		# Want to approach. The farther we are the faster we want to move.
		context_map.assign_interest_vector(direction)


func _get_vector_to_target() -> Vector2:
	var target_pos := Globals.player.global_position
	var self_pos := body.global_position
	return target_pos - self_pos
