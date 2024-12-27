class_name AvoidTerrainBehaviour
extends SteeringBehaviour

## Avoid terrain.

@export var terrain_detector: TerrainDetector


func _fill_context_map(context_map: SteeringContextMap, delta: float) -> void:
	var collisions := terrain_detector.get_collisions(delta)
	for i in range(collisions.size()):
		if collisions[i] > 0.0:
			var direction := terrain_detector.get_direction(i)
			context_map.assign_danger_vector(direction * collisions[i])
