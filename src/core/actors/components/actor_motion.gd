@tool
class_name ActorMotion
extends Node

## Controls the velocity and facing of a parent [CharacterBody2D] node.
##
## Controls the velocity of a parent [CharacterBody2D] node. Also remembers its
## last non-zero velocity to represent the parent body's "facing" even when
## stationary.


## The velocity the parent [CharacterBody2D] moves at. Also sets
## [member direction] when not zero.
@export var velocity := Vector2.ZERO:
	set(value):
		velocity = value
		if velocity.length_squared() > 0:
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
		if _direction.length_squared() == 0.0:
			_direction = Vector2.DOWN


var _direction := Vector2.DOWN # Default to facing south


func move_velocity_toward(target_velocity: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(target_velocity, delta)


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
