extends State

@export var character: CharacterBody2D
@export var moveSpeed := 40

func enter() -> void:
	print("entrando no estado moving")

func behave(_delta: float) -> void:
	var direction := character.get_global_mouse_position() - character.global_position
	
	character.velocity = direction.normalized() * moveSpeed

func exit() -> void:
	print("saindo no estado moving")
