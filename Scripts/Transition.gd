extends Resource
class_name Transition

# Refere-se diretamente a um Node do tipo State
@export var transition_to: NodePath

@export var true_conditions: Array[StringName]

@export var false_conditions: Array[StringName]
