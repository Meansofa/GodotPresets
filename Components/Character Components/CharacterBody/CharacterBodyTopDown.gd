extends CharacterBody2D
#This is a Top Down character meaning it can't jump
class_name CharacterBodyTopDown

@export_category("Variables")
@export var SPEED : float = 300.0 :
	get:
		return SPEED
		
@export_category("Booleans")
@export var can_move : bool = true #incase you want to toggle movement
@export var can_dash : bool = true

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING #Set the motion mode to floating, since it is topdown check the motion mode because if it is at Grounded there will complications, (any object on top will attach to the player and move as fast as it does)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _movement(direction : Vector2, delta : float):
	if !can_move:
		return
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
