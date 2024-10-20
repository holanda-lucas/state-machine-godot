extends State

@export var character: CharacterBody2D
@export var speed = 40

var direction: Vector2 = Vector2.ZERO

func enter() -> void:
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	

func behave(delta: float) -> void:
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	character.velocity = direction * speed
