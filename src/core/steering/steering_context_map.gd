class_name SteeringContextMap

var _interests: Array[float] = []
var _dangers: Array[float] = []

var _heading_directions: Array[Vector2] = []


var resolution: int:
	get:
		assert(_dangers.size() == _interests.size())
		return _interests.size()


func _init(size: int) -> void:
	_interests.resize(size)
	_dangers.resize(size)

	_heading_directions.resize(size)
	_init_heading_directions()


func _to_string() -> String:
	var intersts_string := ", ".join(_interests.map(func(weight): return "%.3f" % weight))
	var dangers_string := ", ".join(_dangers.map(func(weight): return "%.3f" % weight))
	return "{interests: [%s]; dangers: [%s]}" % [intersts_string, dangers_string]


func get_heading_angle(heading: int) -> float:
	return (TAU / float(resolution)) * heading


func get_heading_direction(heading: int) -> Vector2:
	return _heading_directions[heading]


func get_interest(heading: int) -> float:
	return _interests[heading]


func assign_interest(heading: int, weight: float) -> void:
	_assign_weight(_interests, heading, weight)


func assign_interest_vector(vector: Vector2) -> void:
	_assign_vector_weight(_interests, vector)


func get_danger(heading: int) -> float:
	return _dangers[heading]


func assign_danger(heading: int, weight: float) -> void:
	_assign_weight(_dangers, heading, weight)


func assign_danger_vector(vector: Vector2) -> void:
	_assign_vector_weight(_dangers, vector)


## Gets a vector whose length is between 0 and 1.
func get_vector() -> Vector2:
	var combined_heading := Vector2.ZERO
	for i in resolution:
		combined_heading += _heading_directions[i] \
				* clampf(_interests[i] - _dangers[i], 0.0, 1.0)
	return combined_heading.limit_length()


func _init_heading_directions() -> void:
	for i in range(resolution):
		var heading := Vector2.RIGHT.rotated(get_heading_angle(i))
		_heading_directions[i] = heading


func _assign_weight(map: Array[float], heading: int, weight: float) -> void:
	if not is_zero_approx(weight) and (map[heading] < weight):
		map[heading] = weight


func _assign_vector_weight(map: Array[float], vector: Vector2) -> void:
	for i in range(resolution):
		var weight := _heading_directions[i].dot(vector)
		_assign_weight(map, i, weight)
