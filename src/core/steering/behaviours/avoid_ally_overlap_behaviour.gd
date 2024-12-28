class_name AvoidAllyOverlapBehaviour
extends SteeringBehaviour

@export var body: Node2D
@export var avoid_radius := 16.0
@export var mult := 4.0
@export var actor_detector: ActorDetector


func _fill_context_map(context_map: SteeringContextMap, _delta: float) -> void:
	for a in actor_detector.visible_actors:
		if _is_ally(a):
			var vector := _actor_vector(a)
			var distance := vector.length()
			var direction := vector / distance

			var diff := clampf((avoid_radius - distance) / avoid_radius,
					0.0, 1.0)
			context_map.assign_danger_vector(direction * diff * mult)


func _is_ally(actor: Actor) -> bool:
	return actor != Globals.player


func _actor_vector(actor: Actor) -> Vector2:
	return actor.global_position - body.global_position
