# EXAMPLE NODE OF A STATE
# 1. It MUST have a change_conditions string array.
# 2. It MUST implement a behave void, wich is going to be called every frame by the state machine
extends Node
class_name State

@export var transitions: Array[Transition] = []

func enter() -> void:
	pass

func behave(_delta) -> void:
	pass

func exit() -> void:
	pass
