# EXAMPLE NODE OF A STATE
# 1. It MUST have a change_conditions string array.
# 2. It MUST implement a behave void, wich is going to be called every frame by the state machine
extends Node

@export var change_conditions: Array[String] 

func behave() -> void:
	pass
