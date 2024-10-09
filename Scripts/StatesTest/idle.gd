extends State

@export var character: CharacterBody2D

func enter() -> void:
	character.velocity = Vector2.ZERO
	print("entrando no estado idle")

func behave(_delta: float) -> void:
	pass

func exit() -> void:
	print("saindo no estado idle")
