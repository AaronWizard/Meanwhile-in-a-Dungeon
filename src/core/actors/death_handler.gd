class_name DeathHandler
extends Node

@export var hp: ActorHP

@export var anim_player: AnimationPlayer
@export var anim_name: StringName

@export var knockback: Knockback

@export var hurtbox: Hurtbox
@export var hitboxes: Array[Hitbox]


func _ready() -> void:
	hp.damaged.connect(_check_death)


func _check_death(_damage: int) -> void:
	if not hp.is_alive:
		if knockback:
			await knockback.finished

		hurtbox.invincible = true
		for box in hitboxes:
			box.active = false

		anim_player.play(anim_name)
