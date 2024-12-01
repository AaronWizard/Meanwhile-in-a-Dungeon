extends ActorState


@export var player_input: PlayerInput
@export var body: CharacterBody2D
@export var max_speed := 100.0


func process(_delta: float) -> StringName:
	body.velocity = player_input.move_vector * max_speed
	return player_input.desired_state


func physics_process(_delta: float) -> StringName:
	body.move_and_slide()
	return &""
