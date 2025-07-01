class_name NodeStateMachine
extends Node

@export var initial_node_state : NodeState
@export var node_item : DataTypes.Items = DataTypes.Items.None

var node_states : Dictionary = {}
var current_node_state : NodeState
var current_node_state_name : String

# 游戏开始时,状态节点的子节点将被激活,将这些子节点,保存到 note_states 字典中
func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
	
	if initial_node_state:
		initial_node_state._on_enter()
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()
		
func _process(delta : float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()
		
		if node_item == DataTypes.Items.Chicken:
			print( "Item:", node_item ," Current State: ", current_node_state_name)


func transition_to(node_state_name : String) -> void:
	if node_state_name == current_node_state.name.to_lower():
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state._on_exit()
	
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()
	#print("Current State: ", current_node_state_name)
