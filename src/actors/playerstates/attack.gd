extends ActorState

@export var player_input: PlayerInput
@export var body: CanvasItem

@onready var _motion_direction_animation := $MotionDirectionAnimation \
		as MotionDirectionAnimation

var anim_running := false


func _ready() -> void:
	_motion_direction_animation.animation_finished.connect(
		func(): anim_running = false
	)


func enter() -> void:
	_motion_direction_animation.active = true
	anim_running = true


func exit() -> void:
	assert(anim_running == false)
	_motion_direction_animation.active = false


func process(_delta: float) -> StringName:
	if not anim_running:
		return player_input.desired_state
	return &""
