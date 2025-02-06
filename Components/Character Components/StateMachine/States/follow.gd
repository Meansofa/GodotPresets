extends State
class_name follow

@export var character : CharacterBody2D #Character that this state is attached to
@export var player : CharacterBody2D #the one that the character is following

@export_category("Variables")
@export var move_speed := 40.0
@export var follow_distance := 500 #important to set this beyond the size of the collision of the player

func initialize(): #initialize the values of the variables
	move_speed = character.SPEED
	player = get_tree().get_first_node_in_group("Player") #Must assign the player to the group Player for this to work

func Enter():
	initialize()

func Physics_Update(delta: float):
	var distance = player.global_position - character.global_position
	
	if distance.length() > follow_distance: #check if player is out of reach so go back to idle State
		Transitioned.emit(self, "idle")
	else: #if player is in sight, follow the player
		character.velocity = distance.normalized() * move_speed * delta * 60
