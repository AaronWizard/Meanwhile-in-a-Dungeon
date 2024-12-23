@tool
class_name FootstepSoundManager
extends Node

const FOOTSTEP_SOUND_FILE_PATTERN := \
		"res://assets/audio/footsteps/footstep_%s.wav"

@export var stream_player: AudioStreamPlayer2D

var _current_footstep_id := ""


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not _get_actor():
		result.push_back("The owner needs to be an Actor")
	return result


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var current_map := _get_actor().map
	if current_map:
		var current_pos := _get_actor().global_position
		var footstep_id := current_map.get_footstep_sound_name(current_pos)
		if footstep_id != _current_footstep_id:
			_set_footstep_id(footstep_id)


func _set_footstep_id(footstep_id: String) -> void:
	_current_footstep_id = footstep_id
	var sound_file := FOOTSTEP_SOUND_FILE_PATTERN % footstep_id
	var was_playing = stream_player.playing
	if was_playing:
		stream_player.stop()
	stream_player.stream = load(sound_file) as AudioStream
	if was_playing:
		stream_player.play()


func _get_actor() -> Actor:
	return owner as Actor
