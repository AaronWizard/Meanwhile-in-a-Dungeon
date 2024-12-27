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


func get_interest(heading: int) -> float:
	return _interests[heading]


func assign_interest(heading: int, value: float) -> void:
	# Negative values will not be assigned.
	if _interests[heading] < value:
		_interests[heading] = value


func assign_interest_vector(vector: Vector2) -> void:
	for i in range(resolution):
		var value := _heading_directions[i].dot(vector)
		assign_interest(i, value)


func get_danger(heading: int) -> float:
	return _dangers[heading]


func assign_danger(heading: int, value: float) -> void:
	# Negative values will not be assigned.
	if _dangers[heading] < value:
		_dangers[heading] = value


func assign_danger_vector(vector: Vector2) -> void:
	for i in range(resolution):
		var value := _heading_directions[i].dot(vector)
		assign_danger(i, value)


func combine_with(other: SteeringContextMap) -> void:
	if resolution != other.resolution:
		push_error("Context maps have different resolutions: %d, %d" \
				% [resolution, other.resolution])
		return

	for h in range(resolution):
		assign_interest(h, other.get_interest(h))
		assign_danger(h, other.get_danger(h))


## Gets a vector whose length is between 0 and 1.
func get_vector() -> Vector2:
	var result := Vector2.ZERO
	for i in resolution:
		result += _heading_directions[i] \
				* clampf(_interests[i] - _dangers[i], 0.0, 1.0)
	return result.normalized()


func _init_heading_directions() -> void:
	var angle_diff := TAU / float(resolution)
	for i in range(resolution):
		var heading_angle := angle_diff * float(i)
		var heading := Vector2.RIGHT.rotated(heading_angle)
		_heading_directions[i] = heading
