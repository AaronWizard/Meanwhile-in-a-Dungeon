class_name FollowEnemyBehaviour
extends SteeringBehaviour

## Follows an enemy at a certain range.

## Distance to follow target at in pixels. Will move away if closer.
@export_range(0.0, 1.0, 1.0, "or_greater") var follow_radius := 0.0

## In pixels per second squared.
@export var acceleration := 1000.0

@export var body: Node2D

@export var debug_draw := false


func _ready() -> void:
	if debug_draw:
		body.draw.connect(_debug_draw)


func _process(_delta: float) -> void:
	if debug_draw:
		body.queue_redraw()


func _fill_context_map(context_map: SteeringContextMap, delta: float) -> void:
	var target_vector := _get_vector_to_target()
	var distance := target_vector.length()
	var direction := target_vector / distance

	var diff := distance - follow_radius

	var weight := 0.0
	if follow_radius > 0.0:
		weight = clampf(diff / follow_radius, -1, 1)
	else:
		weight = clampf(diff / (acceleration * delta), 0, 1)

	context_map.assign_interest_vector(direction * weight)


func _get_vector_to_target() -> Vector2:
	var target_pos := Globals.player.global_position
	var self_pos := body.global_position
	return target_pos - self_pos


func _debug_draw() -> void:
	var target_vector := _get_vector_to_target()

	body.draw_line(Vector2.ZERO, target_vector, Color.YELLOW, 1)

	var distance := target_vector.length()
	var direction := target_vector / distance

	var diff := distance - follow_radius

	var color: Color
	if diff > 0.0:
		color = Color.LIGHT_BLUE
	else:
		color = Color.DARK_BLUE

	body.draw_line(Vector2.ZERO, target_vector, color, 1)

	body.draw_line(Vector2.ZERO, direction * diff, Color.CYAN, 1)
