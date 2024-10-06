# TODO: Melhorar o gerador de grafos

class_name StateMachine
extends Node

# Guarda os estados e o índice do estado atual
var _states: Array[State] = []
var _currentState: State

# Dicionário das condições
var _conditions: Dictionary

var can_process := false

func _init_states() -> void:
	for child in get_children() as Array[State]:
		_states.append(child)
		
		for transition in child.transitions:
			for condition in transition.true_conditions:
				_conditions[condition] = false
				
			for condition in transition.false_conditions:
				_conditions[condition] = false
	
	_currentState = get_child(0)


# Verifica possíveis trocas
# Primeiro, itera sobre as tanssições do estado atual
# Para cada tansição, ele verifica se todas as condições etão sendo compridas
# Se todas as condições forem compridas, ele retorna o novo estado
# Se não, retorna null
func _check_state_change() -> State:
	for transition in _currentState.transitions:
		if check_conditions(transition):
			print(transition.transition_to)
			return _currentState.get_node(transition.transition_to) as State
		
	return null

#erifica todas as condições estabelecidas pelo estado
func check_conditions(transition: Transition) -> bool:
	for condition in transition.true_conditions:
		if not _conditions[condition]:
			return false
	
	for condition in transition.false_conditions:
		if _conditions[condition]:
			return false
	
	return true

# Funciona como setter das conditions para scripts externos
# Garante que toda vez que um valor muda, seja feita a verificação de mudança de estado
func change_condition(key:String, value: bool) -> void:
	_conditions[key] = value
	var next_state := _check_state_change()
	if (next_state != null):
		_currentState = next_state


# /////////////////////////////////////////////////////////////////////////////

func _ready() -> void:
	_init_states()
	
	can_process = true


func _process(delta: float) -> void:
	if can_process:
		print(_conditions)
		_currentState.behave()
