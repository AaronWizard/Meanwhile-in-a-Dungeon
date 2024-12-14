extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var deceleration := 12.0

@export var hp: ActorHP
@export var death_anim: StringName


func enter() -> void:
	direction_animation_player.set_animation_set(direction_anim_set)


func exit() -> void:
	pass


func process(_delta: float) -> StringName:
	if not hp.is_alive:
		return death_anim
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	return player_input.desired_state
