extends CharacterBodyTopDown

#TODO: meow
#FIXME: MEOW
#HACK
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_movement(direction, delta)
	
	move_and_slide()
