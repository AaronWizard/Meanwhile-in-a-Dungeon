class_name RandomStreamPlayer2D
extends AudioStreamPlayer2D

@export var all_streams: Array[AudioStream] = []

var _stream_queue: Array[int] = []

func _ready() -> void:
	_build_queue()


func play_random() -> void:
	var next_index := _stream_queue.pop_back() as int
	if _stream_queue.is_empty():
		_build_queue()

	stream = all_streams[next_index]
	play()


func _build_queue() -> void:
	_stream_queue.resize(all_streams.size())
	for i in range(all_streams.size()):
		_stream_queue[i] = i
	_stream_queue.shuffle()
