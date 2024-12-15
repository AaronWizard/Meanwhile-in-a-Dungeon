extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var deceleration := 12.0

@export var knockback: Knockback
@export var stunned_state := &"Stunned"


func enter() -> void:
	direction_animation_player.set_animation_set(direction_anim_set)


func process(_delta: float) -> StringName:
	if knockback.is_flying_back:
		return stunned_state
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	return player_input.desired_state
