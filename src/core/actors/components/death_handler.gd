@tool
class_name DeathHandler
extends Node

@export var hp: ActorHP:
	set(value):
		hp = value
		update_configuration_warnings()


@export var remove_owner_on_death := true

@export var anim_player: AnimationPlayer
@export var anim_name: StringName

@export var knockback: Knockback

@export var hurtbox: Hurtbox
@export var hitboxes: Array[Hitbox]


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not hp:
		result.append("Need an ActorHP")
	return result


func _ready() -> void:
	if not Engine.is_editor_hint():
		hp.damaged.connect(_check_death)


func _check_death(_damage: int) -> void:
	if not hp.is_alive:
		if knockback:
			await knockback.finished
		if hurtbox:
			hurtbox.invincible = true
		for box in hitboxes:
			box.active = false
		if anim_player:
			anim_player.play(anim_name)

		if remove_owner_on_death:
			await anim_player.animation_finished
			owner.queue_free()
