class_name ActorDirectionalAttackState
extends ActorState

@export var next_state := &"Idle"

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


func physics_process(delta: float) -> StringName:
	_move_body(
		body.velocity.move_toward(Vector2.ZERO, deceleration * delta)
	)
	if not anim_running:
		return next_state
	return &""
