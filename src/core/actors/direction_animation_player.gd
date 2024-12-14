class_name DirectionAnimationPlayer
extends Node

signal animation_finished

@export var animation_player: AnimationPlayer
@export var motion: ActorMotion

@export var animation_sets: Array[DirectionAnimationSet] = []

var _anim_sets_by_name := {}
var _current_anim_set := &""

var _current_anim_name := &""
var _last_cardinal := Vector2.ZERO


func _ready() -> void:
	for anim_set in animation_sets:
		_anim_sets_by_name[anim_set.anim_set_name] = anim_set
	set_animation_set(animation_sets[0].anim_set_name)

	animation_player.animation_finished.connect(_animation_finished)
	_update_animation()


func _process(_delta: float) -> void:
	if _get_current_anim_set().change_with_direction:
		_update_animation()


func set_animation_set(anim_set_name: StringName) -> void:
	_current_anim_set = anim_set_name
	_update_animation()


func _update_animation() -> void:
	_current_anim_name = _get_current_anim_set().get_animation_name(
			motion.direction)
	_last_cardinal = _get_current_cardinal()
	animation_player.play(_current_anim_name)


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
		result = _get_current_anim_set().get_closest_cardinal(motion.direction)

	return result


func _get_current_anim_set() -> DirectionAnimationSet:
	return _anim_sets_by_name[_current_anim_set]


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == _current_anim_name:
		animation_finished.emit()
