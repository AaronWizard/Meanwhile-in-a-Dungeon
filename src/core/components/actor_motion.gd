@tool
class_name ActorMotion
extends Node

## Controls the velocity and facing of a parent [CharacterBody2D] node.
##
## Controls the velocity of a parent [CharacterBody2D] node. Also remembers its
## last non-zero velocity to represent the parent body's "facing" even when
## stationary.


## The velocity the parent [CharacterBody2D] moves at, in pixels per second.
## Also sets [member direction] when not zero.
@export var velocity := Vector2.ZERO:
	set(value):
		velocity = value
		if not velocity.is_zero_approx():
			_direction = velocity.normalized()


## The normalized direction of [member velocity]. Is the direction of the last
## non-zero velocity if [member velocity] is currently zero, representing the
## "facing" of the parent body.[br]
## Defaults to [constant Vector2.DOWN] if the velocity has never been set; the
## parent body faces south by default.
var direction: Vector2:
	get:
		return _direction
	set(value):
		_direction = value.normalized()
		if _direction.is_zero_approx():
			_direction = Vector2.DOWN


var _direction := Vector2.DOWN # Default to facing south


## [param acceleration] is in pixels per second squared. [param delta] is in
## pixels per second.
func accelerate_to_target_velocity(
		target: Vector2, acceleration: float, delta: float) -> void:
	if acceleration < 0:
		push_warning("Acceleration is negative: %.3f" % acceleration)
	velocity = velocity.move_toward(target, acceleration * delta)


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not _get_body():
		result.append("Does nothing unless the parent is a CharacterBody2D")
	return result


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var body := _get_body()
	if body:
		body.velocity = velocity
		body.move_and_slide()


func _get_body() -> CharacterBody2D:
	return get_parent() as CharacterBody2D
