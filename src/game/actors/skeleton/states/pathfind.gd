extends ActorState

@export var nav_agent: NavigationAgent2D

@export_group("Animations")
@export var anim_set_motion := &"move"
@export var anim_set_idle := &"idle"

@export_group("Attack")
@export var attack_range: Area2D
@export var attack_state := &"Attack"

var _is_active := false

var _claimed_melee_slot := -1

var _in_attack_range := false

@onready var _attack_timer := $AttackTimer as Timer


func _ready() -> void:
	nav_agent.max_speed = body.max_speed
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed)
	attack_range.body_entered.connect(_on_attack_range_body_entered)
	attack_range.body_exited.connect(_on_attack_range_body_exited)


func enter() -> void:
	super()
	attack_range.monitoring = true
	_is_active = true


func exit() -> void:
	attack_range.monitoring = false
	_is_active = false


func process(_delta: float) -> StringName:
	return &""


func physics_process(_delta: float) -> StringName:
	if _can_attack():
		_attack_timer.start()
		return attack_state

	_set_target()

	if NavigationServer2D.map_get_iteration_id(
			nav_agent.get_navigation_map()) == 0:
		return &""

	if nav_agent.is_navigation_finished():
		direction_animation_player.direction \
				= Globals.player.global_position - body.global_position
		if _can_attack():
			_attack_timer.start()
			return attack_state
		else:
			return &""

	var next_pos := nav_agent.get_next_path_position()
	var new_velocity \
			:= body.global_position.direction_to(next_pos) * body.max_speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_nav_agent_velocity_computed(new_velocity)

	if body.velocity.is_zero_approx():
		direction_animation_player.set_animation_set(anim_set_idle)
	else:
		direction_animation_player.set_animation_set(anim_set_motion)

	return &""


func _set_target() -> void:
	if _claimed_melee_slot < 0:
		var open_slots := Globals.player.melee_engagement_area.get_open_slots()
		if not open_slots.is_empty():
			var min_dist_sqr := -1.0
			for index in open_slots:
				var slot_pos := Globals.player.melee_engagement_area \
						.get_slot_global_position(index)
				var dist_sqr := body.global_position.distance_squared_to(slot_pos)
				if (min_dist_sqr < 0) or (dist_sqr < min_dist_sqr):
					_claimed_melee_slot = index
					min_dist_sqr = dist_sqr

	if _claimed_melee_slot >= 0:
		Globals.player.melee_engagement_area.claim_slot(_claimed_melee_slot)
		nav_agent.target_position = Globals.player.melee_engagement_area \
				.get_slot_global_position(_claimed_melee_slot)


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if _is_active:
		body.velocity = safe_velocity
		body.move_and_slide()
		direction_animation_player.direction = body.velocity


func _on_attack_range_body_entered(other: Node2D) -> void:
	if other == Globals.player:
		_in_attack_range = true


func _on_attack_range_body_exited(other: Node2D) -> void:
	if other == Globals.player:
		_in_attack_range = false


func _can_attack() -> bool:
	return _in_attack_range and _attack_timer.is_stopped()
