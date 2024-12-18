extends Scene

@export var player_scene: PackedScene

@export var initial_map: PackedScene
@export var initial_spawn_name: StringName

var player: Actor

@onready var _map_container := $MapContainer
@onready var _camera := $PlayerCamera as PlayerCamera
@onready var _player_hp_bar := $UI/PlayerHPBar as HPBar


func _ready() -> void:
	_init_player()
	_load_first_map()


func _init_player() -> void:
	player = player_scene.instantiate() as Actor
	add_child(player) # So we can connect player actor to UI

	remove_child(_camera)
	player.add_child(_camera)

	_player_hp_bar.observe_actor_hp(player.hp)



func _load_first_map() -> void:
	remove_child(player)
	_load_map(initial_map, initial_spawn_name)


func _load_map(map_scene: PackedScene, spawn_name: String) -> void:
	_clear_map()
	assert(_map_container.get_child_count() == 0)
	var new_map := map_scene.instantiate() as Map
	if not new_map:
		push_error("Map scene at '%s' is not a map" % map_scene.resource_path)
	_map_container.add_child(new_map)

	new_map.add_child(player)
	player.position = new_map.get_marker_position(spawn_name)
	_camera.set_bounds(new_map.get_bounds())


func _clear_map() -> void:
	if _map_container.get_child_count() > 0:
		var old_map := _map_container.get_child(0)
		old_map.remove_child(player)
		old_map.queue_free()
