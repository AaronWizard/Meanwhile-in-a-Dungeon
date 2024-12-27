extends State

@export var motion: ActorMotion
@export var terrain_detector: TerrainDetector

@export var direction_animation_player: DirectionAnimationPlayer
@export var anim_set_motion := &"move"
@export var anim_set_idle := &"idle"

@onready var _steering_motion := $SteeringMotion as SteeringMotion


func enter() -> void:
	_steering_motion.is_active = true
	terrain_detector.enabled = true


func exit() -> void:
	_steering_motion.is_active = false
	terrain_detector.enabled = false


func process(_delta: float) -> StringName:
	if motion.velocity.length_squared() <= 2.0:
		direction_animation_player.set_animation_set(anim_set_idle)
	else:
		direction_animation_player.set_animation_set(anim_set_motion)
	return &""


func physics_process(_delta: float) -> StringName:
	return &""
