class_name ActorState
extends State

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var knockback: Knockback
@export var stunned_state := &"Stunned"


func enter() -> void:
	if direction_animation_player and not direction_anim_set.is_empty():
		direction_animation_player.set_animation_set(direction_anim_set)


func process(delta: float) -> StringName:
	if knockback.is_flying_back:
		return stunned_state
	else:
		return _process_main(delta)


## Can be overridden.
func _process_main(_delta: float) -> StringName:
	return &""
