extends ActorState

@export var player_input: PlayerInput
@export var body: CanvasItem

@onready var _timer: Timer = $Timer


func enter() -> void:
	body.modulate = Color.RED
	_timer.start()


func exit() -> void:
	body.modulate = Color.WHITE


func update(_delta: float) -> StringName:
	if _timer.is_stopped():
		return player_input.desired_state
	return &""
