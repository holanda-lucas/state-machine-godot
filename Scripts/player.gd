extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine

func _process(delta: float) -> void:
	var var1 := Input.is_action_pressed("Variable1")
	state_machine.change_condition("var1", var1)
	
	var var2 := Input.is_action_pressed("Variable2")
	state_machine.change_condition("var2", var2)
	
	var var3 := Input.is_action_pressed("Variable3")
	state_machine.change_condition("var3", var3)
	
	
	var x := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var y := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var is_moving :=  y != 0 or x != 0
	state_machine.change_condition("is_moving", is_moving)


func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_mouse_entered() -> void:
	state_machine.change_condition("mouse_entered", true)


func _on_mouse_exited() -> void:
	state_machine.change_condition("mouse_entered", false)
