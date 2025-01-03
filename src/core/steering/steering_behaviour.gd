class_name SteeringBehaviour
extends Node

@export var active := true


func fill_context_map(context_map: SteeringContextMap, delta: float) -> void:
	if active:
		_fill_context_map(context_map, delta)


## Can be overriden.
func _fill_context_map(_context_map: SteeringContextMap, _delta: float) -> void:
	push_error("SteeringBehaviour._fill_context_map not implemented")
