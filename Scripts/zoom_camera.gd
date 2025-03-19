extends Camera2D

#Check Main MEnu since when on main menu the camera is zoomed out
var main_menu_zoom : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.connect("restart", _restart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	zoom.x = (1.0 - value * 0.01) - 0.01
	zoom.y = (1.0 - value * 0.01) - 0.01
	
	zoom = zoom * main_menu_zoom
	print(self.name, ">camera zoom: ", zoom)


func _on_main_menu_visibility_changed() -> void:
	if !%MainMenu.visible: #once the main menu is not visible return to natural zoom
		zoom = zoom * 2
		print(self.name, ">camera zoom: ", zoom)

func _restart(): #revert the zoom to normal
	zoom = zoom * main_menu_zoom 
