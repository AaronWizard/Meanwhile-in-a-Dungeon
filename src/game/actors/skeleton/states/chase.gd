extends PathfindingState

@export var idle_state := &"Idle"

@export_group("Surround")
@export var surround_range := 64.0
@export var surround_state := &"Surround"

@onready var _update_target_timer := $UpdateTargetTimer as Timer


func _ready() -> void:
	super()
	_update_target_timer.timeout.connect(_on_update_target_timer_timeout)


func enter() -> void:
	super()
	_update_target_timer.start()


func exit() -> void:
	super()
	_update_target_timer.stop()


func _process_main(_delta: float) -> StringName:
	var player_pos := Globals.player.global_position
	var self_pos := _body.global_position

	if self_pos.distance_squared_to(player_pos) \
			<= (surround_range * surround_range):
		return surround_state

	return &""


func _on_update_target_timer_timeout() -> void:
	_set_target()


func _get_new_target() -> Vector2:
	return Globals.player.global_position
