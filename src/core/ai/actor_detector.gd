class_name ActorDetector
extends Area2D

@export var debug_draw := false


var visible_actors: Array[Actor]:
	get:
		return _visible_actors.duplicate()


var _visible_actors: Array[Actor] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _draw() -> void:
	if not debug_draw:
		return

	for a in _visible_actors:
		var a_pos := to_local(a.global_position)
		draw_line(Vector2.ZERO, a_pos, Color.SPRING_GREEN)
		draw_circle(a_pos, 3, Color.SPRING_GREEN)


func _process(_delta: float) -> void:
	if debug_draw:
		queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body != owner:
		var actor := body as Actor
		if actor and actor.hp.is_alive:
			_add_actor(actor)


func _on_body_exited(body: Node2D) -> void:
	var actor := body as Actor
	if actor and (actor in _visible_actors):
		_remove_actor(actor)


func _on_actor_hp_changed(_delta: int, actor: Actor) -> void:
	if not actor.hp.is_alive:
		_remove_actor(actor)


func _add_actor(actor: Actor) -> void:
	_visible_actors.append(actor)
	actor.hp.changed.connect(_on_actor_hp_changed.bind(actor))


func _remove_actor(actor: Actor) -> void:
	_visible_actors.erase(actor)
	actor.hp.changed.disconnect(_on_actor_hp_changed)
