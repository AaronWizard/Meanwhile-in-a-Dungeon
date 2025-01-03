class_name ApproachTargetBehaviour
extends SteeringBehaviour

## Follows an enemy at a certain range.

@export var target_global_pos := Vector2.ZERO

## How close to get to target in pixels. Will move away if too close.
@export_range(0.0, 1.0, 1.0, "or_greater") var radius := 0.0

@export var body: Actor


func _fill_context_map(context_map: SteeringContextMap, delta: float) -> void:
	var target_vector := _target_vector()
	var distance := target_vector.length()
	var direction := target_vector / distance

	var diff := distance - radius

	var weight := diff / (body.max_speed * delta)
	weight = clampf(weight, -1, 1)

	context_map.assign_interest_vector(direction * weight)


func _target_vector() -> Vector2:
	return target_global_pos - body.global_position
