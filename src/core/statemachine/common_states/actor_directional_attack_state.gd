class_name ActorDirectionalAttackState
extends ActorState

@export var next_state := &"Idle"

var anim_running := false


func _ready() -> void:
	direction_animation_player.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	super()
	anim_running = true


func physics_process(delta: float) -> StringName:
	_move_body(Vector2.ZERO, delta)
	if not anim_running:
		return next_state
	return &""
