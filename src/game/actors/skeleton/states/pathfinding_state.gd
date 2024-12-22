class_name PathfindingState
extends ActorState

@export_group("Motion")
@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0

@export_group("Pursuit")
@export var nav_agent: NavigationAgent2D

var _body: Node2D
var _active := false


func _ready() -> void:
	_body = owner as Node2D
	nav_agent.velocity_computed.connect(_on_velocity_computed)


func enter() -> void:
	super()
	_active = true
	_set_target()


func exit() -> void:
	_active = false


func physics_process(_delta: float) -> StringName:
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) \
			== 0:
		return &""
	if nav_agent.is_navigation_finished():
		return _on_reach_destination()

	var next_pos := nav_agent.get_next_path_position()
	var next_velocity := _body.global_position.direction_to(next_pos) \
			* max_speed
	nav_agent.velocity = next_velocity

	return &""


func _on_velocity_computed(velocity: Vector2) -> void:
	if _active:
		actor_motion.velocity = velocity


func _set_target() -> void:
	nav_agent.target_position = _get_new_target()


## Can be overriden.
func _get_new_target() -> Vector2:
	return _body.global_position


## Returns next state. Can be overriden.
func _on_reach_destination() -> StringName:
	return &""
