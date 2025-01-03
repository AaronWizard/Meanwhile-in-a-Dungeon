@tool
class_name SteeringMotion
extends Node

const MIN_SPEED := 0.1

## How many headings are in the context map for each behaviour.
@export_range(1, 1, 1, "or_greater") var behaviour_resolution := 8

@export var debug_draw := false

var _last_context_map: SteeringContextMap = null


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if get_child_count() == 0:
		result.append("Needs SteeringBehaviours to do anything")
	for c in get_children():
		if not c is SteeringBehaviour:
			result.append("'%s' is not a SteeringBehaviour" % c.name)
	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if debug_draw and (owner is Node2D):
		(owner as Node2D).draw.connect(_debug_draw)


func get_velocity(delta: float) -> Vector2:
	var context_map := _get_combined_context_map(delta)

	var result := context_map.get_vector()
	# Prevent jitter
	if result.length_squared() < (MIN_SPEED * MIN_SPEED):
		result = Vector2.ZERO

	if debug_draw and (owner is Node2D):
		_last_context_map = context_map
		(owner as Node2D).queue_redraw()

	return result


func _get_combined_context_map(delta: float) -> SteeringContextMap:
	var context_map := SteeringContextMap.new(behaviour_resolution)
	for behaviour in _get_behaviours():
		behaviour.fill_context_map(context_map, delta)
	return context_map


func _get_behaviours() -> Array[SteeringBehaviour]:
	var result: Array[SteeringBehaviour] = []
	result.assign(get_children())
	return result


func _debug_draw() -> void:
	if _last_context_map:
		for i in behaviour_resolution:
			var interest_weight := _last_context_map.get_interest(i)
			var danger_weight := _last_context_map.get_danger(i)
			var direction := _last_context_map.get_heading_direction(i)

			(owner as Node2D).draw_line(
					Vector2.ZERO, direction * 24, Color.BLUE)

			var colour: Color
			var vector: Vector2
			if interest_weight > danger_weight:
				colour = Color.GREEN
				vector = direction * (interest_weight - danger_weight)
			else:
				colour = Color.RED
				vector = direction * (danger_weight - interest_weight)

			(owner as Node2D).draw_line(Vector2.ZERO, vector * 24, colour)
