class_name SteeringBehaviour
extends Node


## How many headings are in the context map. Set by the parent
## SteeringBehaviourResolver.
var resolution := 8


## Can be overriden.
func get_context_map(_delta: float) -> SteeringContextMap:
	push_error("SteeringBehaviour.get_context_map not implemented")
	var result := SteeringContextMap.new(resolution)
	return result
