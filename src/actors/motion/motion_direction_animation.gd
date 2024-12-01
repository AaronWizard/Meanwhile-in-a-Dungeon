class_name MotionDirectionAnimation
extends Node

signal animation_finished

@export var motion: ActorMotion

@export var anim_player: AnimationPlayer
@export var anim_north := &""
@export var anim_east := &""
@export var anim_south := &""
@export var anim_west := &""

var active := false

var _current_animation := &""


func _ready() -> void:
	anim_player.animation_finished.connect(_animation_finished)


func _process(_delta: float) -> void:
	var anim_name := &""
	if active:
		var cardinal := _get_cardinal_direction()
		match cardinal:
			Vector2.UP:
				anim_name = anim_north
			Vector2.RIGHT:
				anim_name = anim_east
			Vector2.DOWN:
				anim_name = anim_south
			Vector2.LEFT:
				anim_name = anim_west
			_:
				push_error("Invalid cardinal: %v" % cardinal)
				return

		_current_animation = anim_name
		anim_player.play(anim_name)


func _get_cardinal_direction() -> Vector2:
	var possible_cardinals: Array[Vector2] = []

	if not anim_north.is_empty():
		possible_cardinals.append(Vector2.UP)
	if not anim_east.is_empty():
		possible_cardinals.append(Vector2.RIGHT)
	if not anim_south.is_empty():
		possible_cardinals.append(Vector2.DOWN)
	if not anim_west.is_empty():
		possible_cardinals.append(Vector2.LEFT)

	var result = Vector2.DOWN # Default to facing south
	var min_angle := absf(motion.direction.angle_to(result))

	for cardinal in possible_cardinals:
		var angle := absf(motion.direction.angle_to(cardinal))
		if angle < min_angle:
			min_angle = angle
			result = cardinal

	return result


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == _current_animation:
		animation_finished.emit()
