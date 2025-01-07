@tool
class_name Hurtbox
extends Area2D

## A shape that takes damage from [Hitbox]es.

signal was_hit(damage: int, direction: Vector2)

func _ready() -> void:
	if not Engine.is_editor_hint():
		area_entered.connect(_hitbox_entered)


func _hitbox_entered(hitbox: Hitbox) -> void:
	if hitbox:
		var direction := (global_position - hitbox.global_position).normalized()
		was_hit.emit(hitbox.damage, direction)
