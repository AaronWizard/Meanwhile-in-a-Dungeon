class_name ActorDirectionalAttackState
extends ActorState

@export var next_state := &"Idle"

@export var actor_motion: ActorMotion
@export var deceleration := 8.0

var anim_running := false


func _ready() -> void:
	direction_animation_player.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	super()
	anim_running = true


func _process_main(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	if not anim_running:
		return next_state

	return &""
