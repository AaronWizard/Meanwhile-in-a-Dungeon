@tool
class_name HPBar
extends Control

const _PAUSE_TIME := 0.4
# Pixels per second; smaller numbers are faster
const _SPEED := 0.4


@export_range(1, 1, 1, "or_greater") var max_value := 10:
	get:
		return int(_fill_bar.max_value)
	set(value):
		_fill_bar.max_value = value
		_deplete_bar.max_value = value
		_expand_bar.max_value = value


@export_range(1, 1, 1, "or_greater") var current_value := 10:
	set(value):
		var old_value := current_value
		current_value = clampi(value, 0, max_value)

		var delta := current_value - old_value

		if delta < 0:
			_fill_bar.value = current_value
			_expand_bar.value = current_value
			_animate_change(_deplete_bar, absi(delta))
		elif delta > 0:
			_expand_bar.value = current_value
			_deplete_bar.value = current_value
			_animate_change(_fill_bar, absi(delta))


var _hp: ActorHP

@onready var _fill_bar := $FillBar as Range
@onready var _deplete_bar := $DepleteBar as Range
@onready var _expand_bar := $ExpandBar as Range


func observe_actor_hp(hp: ActorHP) -> void:
	if _hp:
		_hp.changed.disconnect(_hp_changed)
		_hp = null

	_hp = hp
	max_value = _hp.max_hp
	current_value = _hp.current_hp
	_hp.changed.connect(_hp_changed)


func _hp_changed(_delta: int) -> void:
	current_value = _hp.current_hp


func _animate_change(bar: Range, delta: int) -> void:
	create_tween() \
		.tween_property(bar, "value", current_value, delta * _SPEED) \
		.set_delay(_PAUSE_TIME)
