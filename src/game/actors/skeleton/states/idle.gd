extends ActorState

@export_group("Motion")
@export var actor_motion: ActorMotion
@export var deceleration := 12.0

@export_group("Pursuit")
@export var enemy_detector: Area2D
@export var pathfind_state := &"Pathfind"

var _body: Node2D
var _enemy_found := false


func _ready() -> void:
	_body = owner as Node2D
	enemy_detector.monitoring = false
	enemy_detector.body_entered.connect(_on_actor_entered)


func enter() -> void:
	enemy_detector.monitoring = true


func exit() -> void:
	enemy_detector.monitoring = false
	_enemy_found = false


func _process_main(_delta: float) -> StringName:
	actor_motion.move_velocity_toward(Vector2.ZERO, deceleration)
	if _enemy_found:
		return pathfind_state
	return &""


func _on_actor_entered(actor: Actor) -> void:
	if actor and (actor == Globals.player):
		_enemy_found = true
