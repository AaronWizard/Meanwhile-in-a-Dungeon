@tool
class_name MeleeEnagementArea
extends Node2D

const _PATH_SLOT_SHAPE := ^"Slot/CollisionShape2D"


@export_range(0, 1, 1, "or_greater") var radius := 16:
	set(value):
		radius = value

		var angle_diff := TAU / get_child_count()

		for i in range(get_child_count()):
			var slot_pivot := get_child(i) as Node2D
			var slot_area := slot_pivot.get_child(0) as Node2D

			slot_area.position = Vector2.RIGHT * radius
			slot_pivot.rotation = angle_diff * i


@export var slot_shape: Shape2D:
	set(value):
		slot_shape = value
		for c in get_children():
			var slot_area := c.get_node(_PATH_SLOT_SHAPE) as CollisionShape2D
			slot_area.shape = slot_shape
		update_configuration_warnings()


var _blocked_slots: Array[bool] = []
var _claimed_slots: Array[bool] = []

var _slot_areas: Array[Area2D] = []


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not slot_shape:
		result.append("Need a slot shape.")
	return result


func _ready() -> void:
	radius = radius
	slot_shape = slot_shape

	_blocked_slots.resize(get_child_count())
	_claimed_slots.resize(get_child_count())
	_slot_areas.resize(get_child_count())

	for i in get_child_count():
		var slot_pivot := get_child(i)
		var slot_area := slot_pivot.get_child(0) as Area2D

		_slot_areas[i] = slot_area

		slot_area.body_entered.connect(_on_slot_body_entered.bind(i))
		slot_area.body_exited.connect(_on_slot_body_exited.bind(i))


func get_open_slots() -> Array[int]:
	var result: Array[int] = []

	for i in get_child_count():
		if not _claimed_slots[i] and not _blocked_slots[i]:
			result.append(i)

	return result


func get_slot_global_position(index: int) -> Vector2:
	return _slot_areas[index].global_position


func claim_slot(index: int) -> void:
	_claimed_slots[index] = true


func return_slot(index: int) -> void:
	_claimed_slots[index] = false


func _on_slot_body_entered(body: Node2D, index: int) -> void:
	if body != owner:
		_blocked_slots[index] = true


func _on_slot_body_exited(body: Node2D, index: int) -> void:
	if body != owner:
		_blocked_slots[index] = false
