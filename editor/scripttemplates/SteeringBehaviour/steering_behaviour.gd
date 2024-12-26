extends _BASE_


func get_context_map(_delta: float) -> SteeringContextMap:
	push_error("SteeringBehaviour.get_context_map not implemented")
	var result := SteeringContextMap.new(resolution)
	return result
