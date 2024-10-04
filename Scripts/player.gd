extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine

func _process(delta: float) -> void:
	if Input.is_action_pressed("Variable1"):
		state_machine.change_condition("var1", true)
	elif Input.is_action_just_released("Variable1"):
		state_machine.change_condition("var1", false)
		
		
	if Input.is_action_pressed("Variable2"):
		state_machine.change_condition("var2", true)
	elif Input.is_action_just_released("Variable2"):
		state_machine.change_condition("var2", false)
		
		
	if Input.is_action_pressed("Variable3"):
		state_machine.change_condition("var3", true)
	elif Input.is_action_just_released("Variable3"):
		state_machine.change_condition("var3", false)
		
