@tool
class_name Actor
extends CharacterBody2D


var map: Map:
	get:
		return _current_map


var hp: ActorHP:
	get:
		return _hp


var _current_map: Map = null
var _hp: ActorHP


func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	var hps := get_children().filter(func (c): return c is ActorHP)
	if hps.is_empty():
		result.append("Need an ActorHP")
	elif hps.size() > 1:
		result.append(
				"Only the first ActorHP child node '%s' will be public." \
				% hps.front().name)

	return result


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_hp = get_children().filter(func (c): return c is ActorHP)[0] as ActorHP


func _enter_tree() -> void:
	var parent: Node = get_parent()
	while parent:
		if parent is Map:
			_current_map = parent as Map
			break
		else:
			parent = parent.get_parent()


func _exit_tree() -> void:
	_current_map = null
