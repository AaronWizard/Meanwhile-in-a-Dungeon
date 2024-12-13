extends Node

@export_file("*.tscn") var initial_scene_path: String


func _ready() -> void:
	_switch_scene(initial_scene_path)


func _switch_scene(scene_path: String) -> void:
	var new_scene: Scene

	var new_scene_file := load(scene_path) as PackedScene
	if not new_scene_file:
		push_error("'%s' is not a scene path" % new_scene_file)
	else:
		new_scene = new_scene_file.instantiate() as Scene

	if not new_scene:
		push_error("Scene is not of type 'Scene'")
		return

	if get_child_count() > 0:
		assert(get_child_count() == 1)
		var child := get_child(0) as Scene
		remove_child(get_child(0))
		child.scene_switch_requested.disconnect(_switch_scene)
		child.queue_free()

	assert(get_child_count() == 0)

	@warning_ignore("return_value_discarded")
	new_scene.scene_switch_requested.connect(_switch_scene)
	add_child(new_scene)
