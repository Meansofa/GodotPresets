extends Node
class_name StateMachine

@export var initial_state : State #The starting state

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child #create a dictionary with the name of the child and has the value of the child
			child.Transitioned.connect(on_child_transition) #connect the child which has a signal Transitioned, when the signal is emited run the function on_child_transition
	
	if initial_state: #check if initial state is not null
		initial_state.Enter() #Enter that state
		current_state = initial_state #Set the current state to that state

# _process() is called every frame
func _process(delta: float) -> void:
	if current_state: #Only run the Update of the current state, this also checks if current state is null
		current_state.Update(delta)

# _physics_process() is always called at a fixed rate(physics process tick rate will always be equal to your monitor refresh rate.)
func _physics_process(delta: float) -> void:
	if current_state: #Only run the Physics Update of the current state, , this also checks if current state is null
		current_state.Physics_Update(delta)

#Runs when the State emits a Transitioned signal
func on_child_transition(state, new_state_name):
	if state != current_state: #Check if the State is not the current state if it does exit
		return
	
	var new_state : State = states.get(new_state_name.to_lower()) #finds a State that matches the name of the new_state_name
	if !new_state: #if new state is null then exit
		return
	
	if current_state: #Exits the current State
		current_state.Exit()
	
	new_state.Enter() #Enter a new State
	current_state = new_state #Set the current State to the new State
