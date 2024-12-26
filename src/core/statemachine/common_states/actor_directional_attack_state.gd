class_name ActorDirectionalAttackState
extends ActorState

@export var next_state := &"Idle"

@export var actor_motion: ActorMotion
## In pixels per second squared.
@export var deceleration := 1000.0

var anim_running := false


func _ready() -> void:
	direction_animation_player.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	super()
	anim_running = true


func process(delta: float) -> StringName:
	actor_motion.accelerate_to_target_velocity(
			Vector2.ZERO, deceleration, delta)
	if not anim_running:
		return next_state

	return &""
