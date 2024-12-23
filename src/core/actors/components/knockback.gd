@tool
class_name Knockback
extends Node

signal finished

@export var knockback_speed := 200.0
@export var decelleration := 5


@export var hurtbox: Hurtbox:
	set(value):
		hurtbox = value
		update_configuration_warnings()


@export var actor_motion: ActorMotion:
	set(value):
		actor_motion = value
		update_configuration_warnings()


@export var direction_animation_player: DirectionAnimationPlayer
@export var flying_anim_set := &""
@export var stop_anim_set := &""


var is_flying_back: bool:
	get:
		return _flying_back


var _flying_back := false


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	if not hurtbox:
		result.append("Need a Hurtbox")
	if not actor_motion:
		result.append("Need an ActorMotion")

	return result


func _ready() -> void:
	if not Engine.is_editor_hint():
		hurtbox.was_hit.connect(_was_hit)


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() and is_flying_back \
			and (actor_motion.velocity.length_squared() > 0):
		actor_motion.move_velocity_toward(Vector2.ZERO, decelleration)
		if actor_motion.velocity.length_squared() == 0:
			_stop_knockback()


func _was_hit(_damage: int, direction: Vector2) -> void:
	_flying_back = true

	hurtbox.invincible = true
	actor_motion.velocity = direction * knockback_speed

	if direction_animation_player:
		direction_animation_player.set_animation_set(flying_anim_set)


func _stop_knockback() -> void:
	actor_motion.direction = -actor_motion.direction
	hurtbox.invincible = false

	if direction_animation_player:
		direction_animation_player.set_animation_set(stop_anim_set)

	_flying_back = false
	finished.emit()
