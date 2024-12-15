@tool
class_name HPBar
extends Control

const _PAUSE_TIME := 0.1
# Pixels per second; smaller numbers are faster
const _SPEED := 0.05


@export var max_value := 10:
	get:
		return int(_fill_bar.max_value)
	set(value):
		_fill_bar.max_value = value
		_deplete_bar.max_value = value
		_expand_bar.max_value = value


@export var current_value := 10:
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


@onready var _fill_bar := $FillBar as Range
@onready var _deplete_bar := $DepleteBar as Range
@onready var _expand_bar := $ExpandBar as Range


func _animate_change(bar: Range, delta: int) -> void:
	await get_tree().create_timer(_PAUSE_TIME).timeout
	create_tween().tween_property(bar, "value", current_value, delta * _SPEED)
