class_name DirectionAnimationSet
extends Resource

@export var anim_set_name := &""

@export var anim_prefix := ""

@export var anim_north := ""
@export var anim_east := ""
@export var anim_south := ""
@export var anim_west := ""

@export var change_with_direction := true


func get_animation_name(direction: Vector2) -> String:
	var result := ""

	var cardinal := get_closest_cardinal(direction)
	match cardinal:
		Vector2.UP:
			result = anim_prefix + anim_north
		Vector2.RIGHT:
			result = anim_prefix + anim_east
		Vector2.DOWN:
			result = anim_prefix + anim_south
		Vector2.LEFT:
			result = anim_prefix + anim_west
		_:
			push_error("Invalid cardinal: %v" % cardinal)
			return ""

	return result


func get_closest_cardinal(direction: Vector2) -> Vector2:
	var cardinals := _get_possible_cardinals()

	var result := cardinals[0]
	var max_dotprod := result.dot(direction)

	for i in range(1, cardinals.size()):
		var cardinal := cardinals[i]
		var dotprod := cardinal.dot(direction)
		if dotprod > max_dotprod:
			result = cardinal
			max_dotprod = dotprod

	return result


func _get_possible_cardinals() -> Array[Vector2]:
	var result: Array[Vector2] = []

	if not anim_north.is_empty():
		result.append(Vector2.UP)
	if not anim_east.is_empty():
		result.append(Vector2.RIGHT)
	if not anim_south.is_empty():
		result.append(Vector2.DOWN)
	if not anim_west.is_empty():
		result.append(Vector2.LEFT)

	return result
