class_name ActorHP
extends Node

signal hp_changed(delta: int)

@export_range(1, 1, 1, "or_greater") var max_hp := 1
@export var hurtbox: Hurtbox


var current_hp: int:
	get:
		return _current_hp


var is_alive: bool:
	get:
		return _current_hp > 0


var _current_hp := 1


func _ready() -> void:
	hurtbox.was_hit.connect(_was_hit)
	_current_hp = max_hp


func _was_hit(damage: int, _direction: Vector2) -> void:
	var old_hp := _current_hp
	_current_hp = clampi(_current_hp - damage, 0, max_hp)

	hp_changed.emit(_current_hp - old_hp)
