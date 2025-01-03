class_name MotionRaycast
extends RayCast2D

@export var body: Actor
@export var base_radius := 16.0


## [param delta] is in seconds.
func get_collision_weight(angle: float, delta: float) -> float:
	var result := 0.0

	var distance := base_radius + (body.max_speed * delta)
	target_position = Vector2.RIGHT.rotated(angle) * distance
	force_raycast_update()
	if is_colliding():
		var collision_pos := to_local(get_collision_point())
		result = 1.0 - (collision_pos.length() / distance)

	return result
