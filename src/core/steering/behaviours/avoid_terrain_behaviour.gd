class_name AvoidTerrainBehaviour
extends SteeringBehaviour

## Avoid terrain.

@export var motion_raycast: MotionRaycast
@export var mult := 5.0


func _fill_context_map(context_map: SteeringContextMap, delta: float) -> void:
	for i in range(context_map.resolution):
		var collision_weight := motion_raycast.get_collision_weight(
			context_map.get_heading_angle(i),
			delta
		)
		context_map.assign_danger(i, collision_weight * mult)
