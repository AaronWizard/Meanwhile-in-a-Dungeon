extends ActorState

@export_group("Motion")
## In pixels per second squared.
@export var deceleration := 1000.0

@export_group("Pursuit")
@export var actor_detector: ActorDetector
@export var chase_state := &"Chase"

var _body: Node2D


func _ready() -> void:
	_body = owner as Node2D


func process(_delta: float) -> StringName:
	if Globals.player in actor_detector.visible_actors:
		return chase_state
	return &""


func physics_process(delta: float) -> StringName:
	_move_body(
		body.velocity.move_toward(Vector2.ZERO, deceleration * delta)
	)
	return &""
