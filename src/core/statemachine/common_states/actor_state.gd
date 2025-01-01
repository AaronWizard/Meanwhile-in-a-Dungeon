class_name ActorState
extends State

@export var body: CharacterBody2D
@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""


func enter() -> void:
	if direction_animation_player and not direction_anim_set.is_empty():
		direction_animation_player.set_animation_set(direction_anim_set)


func _move_body(velocity: Vector2) -> void:
	body.velocity = velocity
	body.move_and_slide()
	direction_animation_player.direction = body.velocity
