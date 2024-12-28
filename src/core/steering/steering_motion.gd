@tool
class_name SteeringMotion
extends Node

const MIN_SPEED := 0.1

@export var motion: ActorMotion

## How many headings are in the context map for each behaviour.
@export_range(1, 1, 1, "or_greater") var behaviour_resolution := 8

## In pixels per second.
@export var max_speed := 100.0
## In pixels per second squared.
@export var acceleration := 1000.0

@export var is_active := false

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

	for b in _get_behaviours():
		b.resolution = behaviour_resolution

	if debug_draw and (owner is Node2D):
		(owner as Node2D).draw.connect(_debug_draw)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if is_active:
		var context_map := _get_combined_context_map(delta)
		var motion_vector := context_map.get_vector()
		# Prevent jitter
		if motion_vector.length_squared() < (MIN_SPEED * MIN_SPEED):
			motion_vector = Vector2.ZERO

		motion.accelerate_to_target_velocity(
				motion_vector * max_speed, acceleration, delta)

		if debug_draw and (owner is Node2D):
			_last_context_map = context_map
			(owner as Node2D).queue_redraw()


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
