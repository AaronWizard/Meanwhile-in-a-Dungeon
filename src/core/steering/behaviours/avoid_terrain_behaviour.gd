class_name AvoidTerrainBehaviour
extends SteeringBehaviour

## Avoid terrain.

## In pixels per second.
@export var max_speed := 100.0


func get_context_map(_delta: float) -> SteeringContextMap:
	push_error("SteeringBehaviour.get_context_map not implemented")
	var result := SteeringContextMap.new(resolution)
	return result
