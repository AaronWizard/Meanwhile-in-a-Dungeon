@tool
class_name Actor
extends CharacterBody2D

## In pixels per second.
@export_range(1, 1, 1, "or_greater") var max_speed := 1.0
## In seconds.
@export_range(0, 1, 0.001, "or_greater") var time_to_max_speed := 0.1


var map: Map:
	get:
		return _current_map


var hp: ActorHP:
	get:
		return _hp


var melee_engagement_area: MeleeEnagementArea:
	get:
		return _melee_engagement_area


var _current_map: Map = null
var _hp: ActorHP
var _melee_engagement_area: MeleeEnagementArea

func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	var hps := get_children().filter(func (c): return c is ActorHP)
	if hps.is_empty():
		result.append("Need an ActorHP")
	elif hps.size() > 1:
		result.append(
				"Only the first ActorHP child node '%s' will be public." \
				% hps.front().name)

	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_hp = get_children().filter(
		func (c): return c is ActorHP
	).front() as ActorHP
	_melee_engagement_area = get_children().filter(
		func (c): return c is MeleeEnagementArea
	).front() as MeleeEnagementArea


func _enter_tree() -> void:
	var parent: Node = get_parent()
	while parent:
		if parent is Map:
			_current_map = parent as Map
			break
		else:
			parent = parent.get_parent()


func _exit_tree() -> void:
	_current_map = null


func move_and_slide_towards_heading(heading: Vector2, delta: float) -> void:
	var new_velocity := heading.limit_length() * max_speed
	if is_zero_approx(time_to_max_speed):
		velocity = new_velocity
	else:
		velocity = velocity.move_toward(
			new_velocity,
			(max_speed / time_to_max_speed) * delta
		)
	move_and_slide()
