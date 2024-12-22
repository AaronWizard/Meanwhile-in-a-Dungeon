extends ActorState

@export_group("Motion")
@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0

@export_group("Pursuit")
@export var nav_agent: NavigationAgent2D
@export var idle_state := &"Idle"

@export_group("Surround")
@export var surround_range := 64
@export var surround_state := &"Surround"

var _body: Node2D
var _active := false

@onready var _target_update_timer := $TargetUpdateTimer as Timer


func _ready() -> void:
	_body = owner as Node2D

	nav_agent.velocity_computed.connect(_on_velocity_computed)
	_target_update_timer.timeout.connect(_on_target_update_timer_timeout)


func enter() -> void:
	super()

	_active = true

	_on_target_update_timer_timeout() # Set chase target
	_target_update_timer.start()


func exit() -> void:
	_active = false
	_target_update_timer.stop()


func _process_main(_delta: float) -> StringName:
	if not _active:
		return idle_state
	if _vector_to_target().length_squared() <= (surround_range * surround_range):
		return surround_state

	return &""


func physics_process(_delta: float) -> StringName:
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) \
			== 0:
		return idle_state
	if nav_agent.is_navigation_finished():
		return idle_state

	var next_pos := nav_agent.get_next_path_position()
	var next_velocity := _body.global_position.direction_to(next_pos) \
			* max_speed
	nav_agent.velocity = next_velocity

	return &""


func _vector_to_target() -> Vector2:
	var player_pos := Globals.player.global_position
	var self_pos := _body.global_position
	return player_pos - self_pos


func _on_velocity_computed(velocity: Vector2) -> void:
	if _active:
		actor_motion.velocity = velocity


func _on_target_update_timer_timeout() -> void:
	nav_agent.target_position = Globals.player.position
