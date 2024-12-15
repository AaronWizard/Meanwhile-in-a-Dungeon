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

	animation_player.animation_finished.connect(_animation_finished)
	set_animation_set(animation_sets[0].anim_set_name)


func _process(_delta: float) -> void:
	if _get_current_anim_set().change_with_direction:
		_update_animation()


func set_animation_set(anim_set_name: StringName) -> void:
	_current_anim_set = anim_set_name
	_update_animation()


func _update_animation() -> void:
	_last_cardinal = _get_current_cardinal()
	var new_anim_name := _get_current_anim_set().get_animation_name(
			_last_cardinal)
	if new_anim_name != _current_anim_name:
		_current_anim_name = new_anim_name
		animation_player.play(_current_anim_name)


func _get_current_cardinal() -> Vector2:
	var result := _get_current_anim_set().get_closest_cardinal(motion.direction)

	var is_moving := motion.velocity.length_squared() > 0
	var is_diagonal := is_equal_approx(
				absf(motion.direction.x), absf(motion.direction.y))
	var is_aligned_with_cardinal := \
			(signf(_last_cardinal.x) == signf(motion.direction.x)) \
			or \
			(signf(_last_cardinal.y) == signf(motion.direction.y))

	if is_moving and is_diagonal and is_aligned_with_cardinal:
		result = _last_cardinal

	return result


func _get_current_anim_set() -> DirectionAnimationSet:
	return _anim_sets_by_name[_current_anim_set]


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == _current_anim_name:
		animation_finished.emit()
