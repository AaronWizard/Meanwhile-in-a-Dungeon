extends ActorState

@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0

@export var nav_agent: NavigationAgent2D

@export var sight_radius := 150
@export var idle_state := &"Idle"

@export var attack_radius := 24
@export var attack_state := &"Attack"

var _body: Node2D
var _keep_chasing := false

@onready var _target_update_timer := $TargetUpdateTimer as Timer
@onready var _chase_timer: Timer = $ChaseTimer


func _ready() -> void:
	_body = owner as Node2D
	nav_agent.velocity_computed.connect(_on_velocity_computed)


func enter() -> void:
	super()

	_keep_chasing = true
	_set_chase_target()

	_target_update_timer.start()
	_chase_timer.start()


func exit() -> void:
	_keep_chasing = false
	_target_update_timer.stop()
	_chase_timer.stop()


func _process_main(_delta: float) -> StringName:
	if not _keep_chasing:
		return idle_state

	var target_vector := _vector_to_target()
	if target_vector.length_squared() <= (attack_radius * attack_radius):
		return attack_state

	return &""


func physics_process(_delta: float) -> StringName:
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) \
			== 0:
		return &""
	if nav_agent.is_navigation_finished():
		return &""

	var next_pos := nav_agent.get_next_path_position()
	var next_velocity := _body.global_position.direction_to(next_pos) \
			* max_speed
	nav_agent.velocity = next_velocity

	return &""


func _vector_to_target() -> Vector2:
	var player_pos := Globals.player.global_position
	var self_pos := _body.global_position
	return player_pos - self_pos


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if _keep_chasing:
		actor_motion.velocity = safe_velocity


func _set_chase_target() -> void:
	nav_agent.target_position = Globals.player.position


func _on_chase_timer_timeout() -> void:
	var target_vector := _vector_to_target()
	if target_vector.length_squared() > (sight_radius * sight_radius):
		_keep_chasing = false
