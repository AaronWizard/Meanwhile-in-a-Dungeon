@tool
class_name FootstepSoundPlayer2D
extends AudioStreamPlayer2D

const FOOTSTEP_SOUND_FILE_PATTERN := \
		"res://assets/audio/footsteps/footstep_%s.wav"


@export var active := false:
	set(value):
		active = value

		if not Engine.is_editor_hint():
			if active and stream:
				play()
			else:
				stop()


var _current_footstep_id := ""


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not _get_actor():
		result.push_back("The owner needs to be an Actor.")

	return result


func _ready() -> void:
	stream = null


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var footstep_id := _get_current_stream_id()
	_change_footsteps(footstep_id)


func _get_current_stream_id() -> String:
	var result := ""
	var current_map := _get_actor().map
	if current_map:
		var current_pos := _get_actor().global_position
		result = current_map.get_footstep_sound_name(current_pos)
	return result


func _change_footsteps(footstep_id: String) -> void:
	var is_new_sound := footstep_id != _current_footstep_id
	_current_footstep_id = footstep_id

	if is_new_sound:
		stop()
		stream = null

		if not _current_footstep_id.is_empty():
			var sound_file := FOOTSTEP_SOUND_FILE_PATTERN % _current_footstep_id
			stream = load(sound_file) as AudioStream
			if active:
				play()


func _get_actor() -> Actor:
	return owner as Actor
