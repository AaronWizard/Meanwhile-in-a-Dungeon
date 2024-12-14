extends State

@export var actor_motion: ActorMotion

@export var anim_player: AnimationPlayer
@export var anim_name: StringName


func enter() -> void:
	if actor_motion:
		actor_motion.velocity = Vector2.ZERO
	anim_player.play(anim_name)
