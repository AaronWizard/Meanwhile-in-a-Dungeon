extends ActorState

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var deceleration := 12.0


func enter() -> void:
	direction_animation_player.set_animation_set(direction_anim_set)


func _process_main(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	return player_input.desired_state
