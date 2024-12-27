@tool
class_name TerrainDetector
extends Node2D

const TERRAIN_LAYER := 1


@export_range(1, 1, 1, "or_greater") var resolution := 8:
	set(value):
		resolution = value
		_build_raycasts()
		_set_raycast_positions(0.0)


@export var max_speed := 100.0
@export var self_radius := 16.0


@export var enabled := true:
	set(value):
		enabled = value
		for c in get_children():
			var raycast := c as RayCast2D
			raycast.enabled = enabled


func _ready() -> void:
	_build_raycasts()
	_set_raycast_positions(0.0)
	enabled = enabled


func get_collisions(delta: float) -> Array[float]:
	_set_raycast_positions(max_speed * delta)

	var result: Array[float] = []
	result.resize(resolution)

	for i in range(resolution):
		var raycast := get_child(i) as RayCast2D
		if raycast.is_colliding():
			var collision_pos := raycast.get_collision_point()
			collision_pos = to_local(collision_pos)
			result[i] = 1.0 \
					- (collision_pos.length() / (max_speed + self_radius))

	return result


func get_direction(index: int) -> Vector2:
	var raycast := get_child(index) as RayCast2D
	return raycast.target_position.normalized()


func _build_raycasts() -> void:
	_clear()

	for i in range(resolution):
		var raycast := RayCast2D.new()
		add_child(raycast)
		raycast.owner = self

		raycast.collision_mask = 0
		raycast.set_collision_mask_value(TERRAIN_LAYER, true)
		raycast.enabled = enabled



func _clear() -> void:
	while get_child_count() > 0:
		var c := get_child(0)
		remove_child(c)
		c.queue_free()


func _set_raycast_positions(distance: float) -> void:
	var angle_diff := TAU / float(resolution)
	for i in range(resolution):
		var angle := float(i) * angle_diff
		var raycast := get_child(i) as RayCast2D
		raycast.target_position = Vector2.RIGHT.rotated(angle) \
				* (distance + self_radius)
