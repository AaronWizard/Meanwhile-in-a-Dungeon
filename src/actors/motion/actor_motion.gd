class_name ActorMotion
extends Node

@export var motion_vector := Vector2.ZERO:
	set(value):
		motion_vector = value
		if motion_vector.length_squared() > 0:
			_direction = motion_vector.normalized()


var direction: Vector2:
	get:
		return _direction


var body: CharacterBody2D:
	get:
		return owner as CharacterBody2D


var _direction := Vector2.DOWN # Default to facing south


func _physics_process(_delta: float) -> void:
	body.velocity = motion_vector
	body.move_and_slide()
