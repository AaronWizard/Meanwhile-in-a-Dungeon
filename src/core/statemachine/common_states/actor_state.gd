class_name ActorState
extends State

@export var knockback: Knockback
@export var stunned_state := &"Stunned"


func process(delta: float) -> StringName:
	if knockback.is_flying_back:
		return stunned_state
	else:
		return _process_main(delta)


## Can be overridden.
func _process_main(_delta: float) -> StringName:
	return &""
