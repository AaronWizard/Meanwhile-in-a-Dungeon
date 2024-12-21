extends ActorState

@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0

@export var nav_agent: NavigationAgent2D

@export var sight_radius := 150
@export var idle_state := &"Idle"

@export var attack_pivot: Node2D
@export var attack_radius := 24
@export var attack_state := &"Attack"

var _body: Node2D
var _keep_chasing := false

@onready var _target_update_timer := $TargetUpdateTimer as Timer
@onready var _chase_timer: Timer = $ChaseTimer


func _ready() -> void:
	_body = owner as Node2D


func enter() -> void:
	super()
	_keep_chasing = true
	nav_agent.target_position = Globals.player.position
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

	var current_pos := _body.global_position
	var next_pos := nav_agent.get_next_path_position()
	var desired_velocity := current_pos.direction_to(next_pos) * max_speed
	actor_motion.move_velocity_toward(desired_velocity, acceleration)
	return &""


func _vector_to_target() -> Vector2:
	var player_pos := Globals.player.global_position + attack_pivot.position
	var self_pos := _body.global_position + attack_pivot.position
	return player_pos - self_pos


func _on_target_update_timer_timeout() -> void:
	nav_agent.target_position = Globals.player.position


func _on_chase_timer_timeout() -> void:
	var target_vector := _vector_to_target()
	if target_vector.length_squared() > (sight_radius * sight_radius):
		_keep_chasing = false
