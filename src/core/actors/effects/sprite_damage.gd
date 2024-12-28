@tool
class_name SpriteDamage
extends Node

@export var sprite: Sprite2D:
	set(value):
		sprite = value
		update_configuration_warnings()


@export var hp: ActorHP:
	set(value):
		hp = value
		update_configuration_warnings()


@export var last_frame_is_death := false


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	if not sprite:
		result.push_back("Need a sprite")
	if sprite and ((sprite.hframes * sprite.vframes) <= 1):
		result.push_back("Sprite needs more than one frame")
	if not hp:
		result.push_back("Need an ActorHP")

	return result


func _ready() -> void:
	_set_frame()
	hp.changed.connect( func(_delta): _set_frame() )


func _set_frame() -> void:
	var frame_percent := 1.0 - hp.percent
	var max_frame := sprite.hframes * sprite.vframes

	if last_frame_is_death:
		max_frame -= 1

	var frame := floori(float(max_frame) * frame_percent)
	if frame >= (sprite.hframes * sprite.vframes):
		sprite.visible = false
	else:
		sprite.frame = frame
