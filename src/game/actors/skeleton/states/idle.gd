extends State

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""


func enter() -> void:
	direction_animation_player.set_animation_set(direction_anim_set)


func exit() -> void:
	pass


func process(_delta: float) -> StringName:
	return &""


func physics_process(_delta: float) -> StringName:
	return &""
