extends AnimationTree

@export var character : CharacterBody2D #The character that the animation tree is going to animate

var last_facing_direction : Vector2 #So the blend position on idle mode is facing the right direction

func _ready() -> void:
	self.active = true #Set the animation tree to active

func _process(delta: float) -> void:
	var is_idle = !character.velocity
	
	if !is_idle: #If not idle
		last_facing_direction = character.velocity.normalized()
	
	#Conditions (inside AnimationTree you can set the condition for each states in the inspector)
	self.set("parameters/conditions/idle", is_idle) #if Idle set the idle condition to true
	self.set("parameters/conditions/run", !is_idle) #if not Idle set the run condition to true
	
	#Animations
	self.set("parameters/Idle/blend_position", last_facing_direction)
	self.set("parameters/Run/blend_position", last_facing_direction)
