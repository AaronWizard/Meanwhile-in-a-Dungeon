class_name Knockback
extends Node

@export var knockback_speed := 200.0
@export var decelleration := 5

@export var hurtbox: Hurtbox
@export var actor_motion: ActorMotion

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var state_machine: StateMachine
@export var knockback_state: StringName
@export var resume_state: StringName


func _ready() -> void:
	hurtbox.was_hit.connect(_was_hit)


func _process(_delta: float) -> void:
	if actor_motion.velocity.length_squared() > 0:
		actor_motion.move_velocity_toward(Vector2.ZERO, decelleration)
		if actor_motion.velocity.length_squared() == 0:
			_stop_knockback()


func _was_hit(_damage: int, direction: Vector2) -> void:
	actor_motion.velocity = direction * knockback_speed

	if state_machine:
		state_machine.switch_state(knockback_state)

	if direction_animation_player:
		direction_animation_player.set_animation_set(direction_anim_set)


func _stop_knockback() -> void:
	actor_motion.direction = -actor_motion.direction

	if state_machine and (state_machine.current_state_name == knockback_state):
		state_machine.switch_state(resume_state)
