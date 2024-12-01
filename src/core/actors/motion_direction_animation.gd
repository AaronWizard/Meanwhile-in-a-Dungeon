class_name MotionDirectionAnimation
extends Node

## Plays an animation depending on the direction of an [ActorMotion] node.
##
## Plays an animation depending on the [member ActorMotion.direction] property
## of an [ActorMotion] node.

## The current animation finished.
signal animation_finished

## The [ActorMotion] motion node whose direction determines the current
## animaiton.
@export var motion: ActorMotion

## The animation player that has the animations.
@export var anim_player: AnimationPlayer

## The animation when the current direction is closest to [constant Vector2.UP].
## Ignored if empty.
@export var anim_north := &""
## The animation when the current direction is closest to
## [constant Vector2.RIGHT]. Ignored if empty.
@export var anim_east := &""
## The animation when the current direction is closest to
## [constant Vector2.DOWN]. Ignored if empty.
@export var anim_south := &""
## The animation when the current direction is closest to
## [constant Vector2.LEFT]. Ignored if empty.
@export var anim_west := &""

## When true, will change the current animation based on the
## [member ActorMotion.direction] property of [member motion].
var active := false

var _current_animation := &""
var _last_cardinal := Vector2.ZERO


func _ready() -> void:
	anim_player.animation_finished.connect(_animation_finished)


func _process(_delta: float) -> void:
	var anim_name := &""
	if active:
		var cardinal := _get_current_cardinal()
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
		_last_cardinal = cardinal

		anim_player.play(anim_name)


func _get_current_cardinal() -> Vector2:
	var result: Vector2
	# If moving perfectly diagonal, face in last cardinal direction if it's an
	# equivalent facing.
	if \
			( \
				absf(motion.direction.x) == absf(motion.direction.y)
			) \
			and \
			( \
				(signf(_last_cardinal.x) == signf(motion.direction.x)) \
				or \
				(signf(_last_cardinal.y) == signf(motion.direction.y)) \
			):
		result = _last_cardinal
	else:
		result = _find_closest_cardinal()

	return result


func _find_closest_cardinal() -> Vector2:
	var possible_cardinals: Array[Vector2] = []

	if not anim_north.is_empty():
		possible_cardinals.append(Vector2.UP)
	if not anim_east.is_empty():
		possible_cardinals.append(Vector2.RIGHT)
	if not anim_south.is_empty():
		possible_cardinals.append(Vector2.DOWN)
	if not anim_west.is_empty():
		possible_cardinals.append(Vector2.LEFT)

	var result := Vector2.DOWN # Default to facing south
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
