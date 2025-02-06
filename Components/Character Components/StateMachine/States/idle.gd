extends State
class_name idle

@export var character : CharacterBody2D #Character that this state is attached to
@export var player: CharacterBody2D #Player

@export_category("Variables")
@export var move_speed := 10.0

#Only If Follow State is attached
@export var follow_distance := 300 #how far the character will follow the player, beyond this will stop following

var move_direction : Vector2 #Direction the character is facing
var wander_time : float #How long the character wanders
var rest_time : float #How long the character will rest(for when it needs to stop moving after it wanders)

func initialize(): #initialize the values of the variables
	move_speed = character.SPEED
	player = get_tree().get_first_node_in_group("Player") #Must assign the player to the group Player for this to work

func Enter():
	initialize()
	randomize_wander()

func Update(delta: float):
	if wander_time > 0: #counts down wander time till 0
		wander_time -= delta #delta counts down 0.0167 seconds every frame, if it's 60 frames per second, then it's 0.0167 * 60 = 1 every second
	elif rest_time > 0:
		rest_time -= delta #count down by seconds
	else:
		randomize_rest()
		randomize_wander()

func Physics_Update(delta: float):
	if character:
		if wander_time > 0: 
			_move(delta)
		else:
			_rest()
		#The move_and_slide(to update the position of the character) can be called from the character's physics process, You can also call character.move_and_slide()

#For Follow State(u dont need to attach a player if you don't want a follow state)
	if player != null:
		var distance = player.global_position - character.global_position
		if distance.length() < 200: #To check if character should follow the player
			print(self, "> detected player: attempting to Follow")
			Transitioned.emit(self, "follow") 
	
func _move(delta): #Move the character
	character.velocity = move_direction *  move_speed * delta * 60

func _rest(): #Stop moving
	character.velocity = Vector2.ZERO

func randomize_rest():
	rest_time = randf_range(1, 3) #set how long the character will rest

func randomize_wander(): #For random idle walks
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3) #set how long the character will wander
