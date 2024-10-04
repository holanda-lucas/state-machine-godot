# TODO: Melhorar o gerador de grafos

class_name StateMachine
extends Node

# Guarda os estados e o índice do estado atual
# State deve implementar:
#	Array de string de nome change_conditions
#	Função behave
var _states = []
var _currentStateIndex: int


# Matriz adjacência das conexões
@export var connection_string: String
var connections = []

# Dicionário das condições
var _conditions: Dictionary

var can_process := false

func _get_adjacency_matrix() -> void:
	var size := int(sqrt(len(connection_string)))
	var line := []

	for i in len(connection_string):
		line.append(int(connection_string[i]))
		
		if (i + 1) % size == 0:
			connections.append(line)
			line = []
			
		

func _init_states() -> void:
	for child in get_children():
		_states.append(child)
		for i in child.change_conditions:
			_conditions[i] = false
	
	_currentStateIndex = 0
	
# Verifica possíveis trocas
# Primeiro, itera sobre as conexões do estado atual
# Para cada conexão, ele itera sobre as exigências daquele estado
# Se estiver se encaixando em todas, retorna o índice da mudança de estado
# Se nehuma conexão estiver batendo com os resultados, retorna -1
func _check_state_change() -> int:
	for i in len(connections):
		if connections[_currentStateIndex][i] == 1:
			var value := -1
			for j in len(_states[i].change_conditions):
				if _conditions[_states[i].change_conditions[j]] == false:
					value = -1
					break
				else:
					value = i
			if value != -1:
				return value
	
	return -1
			
		
		
# Funciona como setter das conditions para scripts externos
# Garante que toda vez que um valor muda, seja feita a verificação de mudança de estado
func change_condition(key:String, value: bool) -> void:
	_conditions[key] = value
	var next_state := _check_state_change()
	
	if (next_state != -1):
		_currentStateIndex = next_state


# /////////////////////////////////////////////////////////////////////////////


func _ready() -> void:
	_init_states()
	
	_get_adjacency_matrix()
	can_process = true


func _process(delta: float) -> void:
	if can_process:
		print(_conditions)
		_states[_currentStateIndex].behave();
