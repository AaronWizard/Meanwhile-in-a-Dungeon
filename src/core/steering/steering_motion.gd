@tool
class_name SteeringMotion
extends Node

@export var motion: ActorMotion

## How many headings are in the context map for each behaviour.
@export_range(1, 1, 1, "or_greater") var behaviour_resolution := 8

@export var is_active := false


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	for c in get_children():
		if not c is SteeringBehaviour:
			result.append("'%s' is not a SteeringBehaviour" % c.name)
	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	for b in _get_behaviours():
		b.resolution = behaviour_resolution


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if is_active:
		var context_map := _get_combined_context_map(delta)
		motion.velocity = context_map.get_vector()


func _get_combined_context_map(delta: float) -> SteeringContextMap:
	var combined_map := SteeringContextMap.new(behaviour_resolution)
	for behaviour in _get_behaviours():
		var new_map := behaviour.get_context_map(delta)
		combined_map.combine_with(new_map)
	return combined_map


func _get_behaviours() -> Array[SteeringBehaviour]:
	var result: Array[SteeringBehaviour] = []
	result.assign(get_children())
	return result
