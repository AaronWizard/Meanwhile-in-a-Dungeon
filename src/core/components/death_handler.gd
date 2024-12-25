@tool
class_name DeathHandler
extends Node

@export_group("HP")
@export var hp: ActorHP:
	set(value):
		hp = value
		update_configuration_warnings()

@export_group("Owner")
@export var collisions_to_disable: Array[CollisionShape2D]
@export var remove_owner_on_death := true
@export var state_machine: StateMachine

@export_group("Animations and Sounds")
@export var anim_player: AnimationPlayer
@export var anim_name: StringName
@export var sound: AudioStreamPlayer2D

@export_group("Knockback")
@export var knockback: Knockback


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not hp:
		result.append("Need an ActorHP")
	return result


func _ready() -> void:
	if not Engine.is_editor_hint():
		hp.changed.connect(_check_death)


func _check_death(_delta: int) -> void:
	if not hp.is_alive:
		if state_machine and state_machine.running:
			state_machine.running = false

		if knockback:
			await knockback.finished

		for c in collisions_to_disable:
			c.set_deferred(&"disabled", true)

		if sound:
			sound.play()
		if anim_player:
			anim_player.play(anim_name)

		if remove_owner_on_death:
			if sound and sound.playing:
				await sound.finished
			if anim_player and anim_player.is_playing():
				await anim_player.animation_finished
			owner.queue_free()
