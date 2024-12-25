class_name ActorState
extends State

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""


func enter() -> void:
	if direction_animation_player and not direction_anim_set.is_empty():
		direction_animation_player.set_animation_set(direction_anim_set)
