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
			result.position.x = mini(result.position.x, used_rect.position.x)
			result.position.y = mini(result.position.y, used_rect.position.y)
			result.size.x = maxi(result.position.x, used_rect.size.x)
			result.size.y = maxi(result.position.y, used_rect.size.y)

	return result


func get_marker_position(marker_name: StringName) -> Vector2:
	var marker := _markers.get_node(NodePath(marker_name)) as Node2D
	if not marker:
		push_error("There is no marker with the name '%s'" % marker_name)
	return marker.position
