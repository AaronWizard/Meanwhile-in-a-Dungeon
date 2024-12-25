@tool
class_name ActorHP
extends Node

signal changed(delta: int)

@export_range(1, 1, 1, "or_greater") var max_hp := 1:
	set(value):
		max_hp = value
		current_hp = mini(current_hp, max_hp)


@export_range(1, 1, 1, "or_greater") var current_hp := 1:
	set(value):
		var old_hp := current_hp
		current_hp = clampi(value, 0, max_hp)

		var delta := current_hp - old_hp
		if delta != 0:
			changed.emit(delta)


@export var hurtbox: Hurtbox:
	set(value):
		hurtbox = value
		update_configuration_warnings()


var is_alive: bool:
	get:
		return current_hp > 0


var percent: float:
	get:
		return float(current_hp) / float(max_hp)


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not hurtbox:
		result.append("Need a Hurtbox")
	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	hurtbox.was_hit.connect(_was_hit)


func _was_hit(damage: int, _direction: Vector2) -> void:
	current_hp -= damage
