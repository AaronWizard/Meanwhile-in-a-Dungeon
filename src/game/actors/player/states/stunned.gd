extends State

@export var knockback: Knockback
@export var hp: ActorHP
@export var next_state := &"Idle"


func process(_delta: float) -> StringName:
	if not knockback.is_flying_back and hp.is_alive:
		return next_state
	return &""
