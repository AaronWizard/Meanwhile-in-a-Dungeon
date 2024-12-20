@tool
class_name Hitbox
extends Area2D

## A shape that does damage to [Hurtbox]es.

@export var faction := 0
@export var damage := 1


@export var active := false:
	get:
		return monitorable
	set(value):
		set_deferred("monitorable", value)


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(PhysicsConstants.HITBOX_LAYER, true)

	monitoring = false
	active = active
