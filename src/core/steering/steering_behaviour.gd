class_name SteeringBehaviour
extends Node


## How many headings are in the context map. Set by the parent
## SteeringBehaviourResolver.
var resolution := 8


func get_context_map(delta: float) -> SteeringContextMap:
	var result := SteeringContextMap.new(resolution)
	_fill_context_map(result, delta)
	return result


## Can be overriden.
func _fill_context_map(_context_map: SteeringContextMap, _delta: float) -> void:
	push_error("SteeringBehaviour._fill_context_map not implemented")
