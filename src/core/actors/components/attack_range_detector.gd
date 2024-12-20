@tool
class_name AttackRangeDetector
extends Area2D

signal hurtbox_detected(hurtbox: Hurtbox)

@export var faction := 0


@export var active := false:
	get:
		return monitoring
	set(value):
		set_deferred("monitoring", value)
		if not value:
			_hurtboxes.clear()


var current_hurtboxes: Array[Hurtbox]:
	get:
		return _hurtboxes


var _hurtboxes: Array[Hurtbox] = []


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(PhysicsConstants.HURTBOX_LAYER, true)

	monitorable = false
	active = active

	if not Engine.is_editor_hint():
		pass


func _hurtbox_entered(hurtbox: Hurtbox) -> void:
	if hurtbox and (hurtbox.faction != faction):
		_hurtboxes.append(hurtbox)
		hurtbox_detected.emit(hurtbox)


func _hurtbox_exited(hurtbox: Hurtbox) -> void:
	if hurtbox and (hurtbox.faction != faction):
		_hurtboxes.erase(hurtbox)
