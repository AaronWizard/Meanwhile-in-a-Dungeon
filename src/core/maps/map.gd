class_name Map
extends Node2D

@onready var _terrain := $Terrain
@onready var _markers := $Markers


func get_bounds() -> Rect2i:
	var result := Rect2i()

	for layer in _terrain.get_children():
		var tile_layer := layer as TileMapLayer
		if tile_layer:
			var used_rect := tile_layer.get_used_rect()
			used_rect.position *= tile_layer.tile_set.tile_size
			used_rect.size *= tile_layer.tile_set.tile_size

			result.position.x = mini(result.position.x, used_rect.position.x)
			result.position.y = mini(result.position.y, used_rect.position.y)
			result.end.x = maxi(result.end.x, used_rect.end.x)
			result.end.y = maxi(result.end.y, used_rect.end.y)

	return result


func get_marker_position(marker_name: StringName) -> Vector2:
	var marker := _markers.get_node(NodePath(marker_name)) as Node2D
	if not marker:
		push_error("There is no marker with the name '%s'" % marker_name)
	return marker.position
