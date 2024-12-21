@tool
class_name Hurtbox
extends Area2D

## A shape that takes damage from [Hitbox]es.

signal was_hit(damage: int, direction: Vector2)

@export var faction := 0


@export var invincible := false:
	get:
		return not monitoring
	set(value):
		set_deferred("monitoring", not value)
		if value:
			_colliding_hitboxes.clear()


## In seconds.
@export var continuing_damage_interval := 1.0

var _colliding_hitboxes := {}
var _current_damage_interval := 0.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(Hitbox.HITBOX_LAYER, true)

	monitorable = false
	invincible = invincible

	if not Engine.is_editor_hint():
		area_entered.connect(_hitbox_entered)
		area_exited.connect(_hitbox_exited)


func _process(delta: float) -> void:
	if not _colliding_hitboxes.is_empty():
		_current_damage_interval += delta
		if _current_damage_interval >= continuing_damage_interval:
			_current_damage_interval -= continuing_damage_interval
			for h in _colliding_hitboxes.keys():
				_get_hit(h)


func _hitbox_entered(hitbox: Hitbox) -> void:
	if not hitbox or (hitbox.faction == faction):
		return

	_colliding_hitboxes[hitbox] = true
	_get_hit(hitbox)


func _hitbox_exited(hitbox: Hitbox) -> void:
	if hitbox:
		_colliding_hitboxes.erase(hitbox)
		if _colliding_hitboxes.is_empty():
			_current_damage_interval = 0.0


func _get_hit(hitbox: Hitbox) -> void:
	var direction := (global_position - hitbox.global_position).normalized()
	was_hit.emit(hitbox.damage, direction)
