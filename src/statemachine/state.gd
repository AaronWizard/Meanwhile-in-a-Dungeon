class_name State
extends Node

## A state in a [StateMachine].


## Invoked when the state becomes the current state.[br]
## Can be overriden.
func enter() -> void:
	pass


## Invoked when the state stops being the current state.[br]
## Can be overriden.
func exit() -> void:
	pass


## Invoked during the state machine's [method Node._process] method. Returns the
## name of the next state, or an empty string if no transition is to occur.[br]
## Can be overriden.
func process(_delta: float) -> StringName:
	return &""


## Invoked during the state machine's [method Node._physics_process] method.
## Returns the name of the next state, or an empty string if no transition is to
## occur.[br]
## Can be overriden.
func physics_process(_delta: float) -> StringName:
	return &""
