@tool
class_name ActorHP
extends Node

signal changed(delta: int)

@export_range(1, 1, 1, "or_greater") var max_hp := 1


@export var hurtbox: Hurtbox:
	set(value):
		hurtbox = value
		update_configuration_warnings()


var current_hp: int:
	get:
		return _current_hp


var is_alive: bool:
	get:
		return _current_hp > 0


var _current_hp := 1


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not hurtbox:
		result.append("Need a Hurtbox")
	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_current_hp = max_hp
	hurtbox.was_hit.connect(_was_hit)


func _was_hit(damage: int, _direction: Vector2) -> void:
	var old_hp := _current_hp
	_current_hp = clampi(_current_hp - damage, 0, max_hp)
	var delta := _current_hp - old_hp
	if delta != 0:
		changed.emit(delta)
