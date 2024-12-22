extends PathfindingState

@export var surround_range_min := 32.0
@export var surround_range_max := 64.0
@export var circling_speed := 100.0
@export var chase_state := &"Chase"

@export_group("Attack")
@export var attack_wait_time_min := 0.1
@export var attack_wait_time_max := 3.0

var _surround_range := 0.0
var _turn_mult := 0

var _can_attack := false

@onready var _attack_timer: Timer = $AttackTimer


func _ready() -> void:
	super()

	_attack_timer.timeout.connect(_on_attack_timer_timeout)

	_surround_range = randf_range(surround_range_min, surround_range_max)
	if randf() < 0.5:
		_turn_mult = -1
	else:
		_turn_mult = 1


func enter() -> void:
	super()
	_can_attack = false
	_attack_timer.wait_time = randf_range(
			attack_wait_time_min, attack_wait_time_max)
	_attack_timer.start()


func exit() -> void:
	super()


func _process_main(_delta: float) -> StringName:
	var target_pos := Globals.player.global_position
	var self_pos := _body.global_position
	if self_pos.distance_squared_to(target_pos) \
			> (surround_range_max * surround_range_max):
		return chase_state

	_set_target()
	return &""


func _get_new_target() -> Vector2:
	var target_pos := Globals.player.global_position
	var self_pos := _body.global_position
	var direction := target_pos.direction_to(self_pos)

	var rotated_direction := direction.rotated(circling_speed * _turn_mult)

	var result := (rotated_direction * _surround_range) + target_pos

	return result


func _on_reach_destination() -> StringName:
	_set_target()
	return &""


func _on_attack_timer_timeout() -> void:
	_can_attack = true
