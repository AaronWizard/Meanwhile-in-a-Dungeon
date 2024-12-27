extends ActorState

@export_group("Motion")
@export var actor_motion: ActorMotion
## In pixels per second squared.
@export var deceleration := 1000.0

@export_group("Pursuit")
@export var actor_detector: ActorDetector
@export var chase_state := &"Chase"

var _body: Node2D


func _ready() -> void:
	_body = owner as Node2D


func process(delta: float) -> StringName:
	actor_motion.accelerate_to_target_velocity(
			Vector2.ZERO, deceleration, delta)
	if Globals.player in actor_detector.visible_actors:
		return chase_state
	return &""
