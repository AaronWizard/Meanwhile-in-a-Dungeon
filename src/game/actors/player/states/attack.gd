extends State

@export var player_input: PlayerInput
@export var actor_motion: ActorMotion

@export var direction_animation_player: DirectionAnimationPlayer
@export var direction_anim_set := &""

@export var deceleration := 8.0

var anim_running := false


func _ready() -> void:
	direction_animation_player.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	direction_animation_player.set_animation_set(direction_anim_set)
	anim_running = true


func process(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	if not anim_running:
		return player_input.desired_state
	return &""
