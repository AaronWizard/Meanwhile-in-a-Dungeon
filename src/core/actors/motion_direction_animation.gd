@tool
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


func _get_configuration_warnings() -> PackedStringArray:
	var result: PackedStringArray = []
	if not motion:
		result.append("ActorMotion node not set")
	if not anim_player:
		result.append("AnimationPlayer node not set")
	if anim_north.is_empty() and anim_east.is_empty() \
			and anim_south.is_empty() and anim_west.is_empty():
		result.append("At least one animation name needs to be set")
	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	anim_player.animation_finished.connect(_animation_finished)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

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

	# Cardinals in order of priority
	if not anim_south.is_empty():
		# Default to facing south, so append this first
		possible_cardinals.append(Vector2.DOWN)
	if not anim_east.is_empty():
		possible_cardinals.append(Vector2.RIGHT)
	if not anim_west.is_empty():
		possible_cardinals.append(Vector2.LEFT)
	if not anim_north.is_empty():
		possible_cardinals.append(Vector2.UP)

	if possible_cardinals.is_empty():
		possible_cardinals.append(Vector2.DOWN)

	var result := possible_cardinals[0]
	var max_dotprod := result.dot(motion.direction)

	for i in range(1, possible_cardinals.size()):
		var cardinal := possible_cardinals[i]
		var dotprod := cardinal.dot(motion.direction)
		if dotprod > max_dotprod:
			max_dotprod = dotprod
			result = cardinal

	return result


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == _current_animation:
		animation_finished.emit()
