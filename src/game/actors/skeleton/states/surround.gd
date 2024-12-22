extends ActorState

@export var surround_range_min := 32.0
@export var surround_range_max := 64.0

@export_group("Motion")
@export var actor_motion: ActorMotion
@export var acceleration := 10.0
@export var max_speed := 100.0
@export var circling_speed := TAU / 15

@export_group("Attack")
@export var attack_wait_time_min := 0.1
@export var attack_wait_time_max := 3.0

@onready var _attack_timer := $AttackTimer as Timer

var _body: Node2D
var _can_attack := false

var _surround_range := 0.0
var _turn_mult := 0


func _ready() -> void:
	_body = owner as Node2D
	_attack_timer.timeout.connect(_on_attack_timer_timeout)

	_surround_range = randf_range(surround_range_min, surround_range_max)

	if randf() < 0.5:
		_turn_mult = -1
	else:
		_turn_mult = 1


func enter() -> void:
	print(owner.name, ": surround started")
	_can_attack = false
	_attack_timer.wait_time = randf_range(
			attack_wait_time_min, attack_wait_time_max)
	_attack_timer.start()


func exit() -> void:
	pass


func _process_main(_delta: float) -> StringName:
	var target_pos := Globals.player.global_position
	var self_pos := _body.global_position

	var direction := target_pos.direction_to(self_pos)
	var rotated_direction := direction.rotated(circling_speed * _turn_mult)

	var desired_location := (rotated_direction * _surround_range) + target_pos

	actor_motion.velocity = self_pos.direction_to(desired_location) * max_speed

	return &""


func _on_actor_entered(actor: Actor) -> void:
	if actor and (actor == Globals.player):
		_can_attack = true


func _on_attack_timer_timeout() -> void:
	_can_attack = true
