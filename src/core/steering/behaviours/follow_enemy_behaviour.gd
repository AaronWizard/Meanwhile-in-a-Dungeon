class_name FollowEnemyBehaviour
extends SteeringBehaviour

## Follows enemies at a certain range.

## In pixels.
@export var follow_radius := 64.0


func get_context_map(_delta: float) -> SteeringContextMap:
	push_error("SteeringBehaviour.get_context_map not implemented")
	var result := SteeringContextMap.new(resolution)
	return result
