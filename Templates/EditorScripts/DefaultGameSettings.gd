@tool extends EditorScript

#Auto edit your settings to the ideal Settings (not for pixel games)
#File > Run 

#Note: 640x360 resolution scales well to 720, 1080, and 1440.
func _run() -> void:
	#Size of the viewport
	ProjectSettings.set("display/window/size/viewport_width", 1280)
	ProjectSettings.set("display/window/size/viewport_height", 720)
	
	#Size of the window
	ProjectSettings.set("display/window/size/window_width_override", 640)
	ProjectSettings.set("display/window/size/window_height_override", 360)
	
	#Layer Names
	ProjectSettings.set("layer_names/2d_physics/layer_1", "Player")
	ProjectSettings.set("layer_names/2d_physics/layer_2", "Enemies")
	ProjectSettings.set("layer_names/2d_physics/layer_3", "Hazards")
	ProjectSettings.set("layer_names/2d_physics/layer_4", "Environment")
	ProjectSettings.set("layer_names/2d_physics/layer_5", "Coins")
	
	ProjectSettings.set("display/window/stretch/mode", "canvas_items") #for full screen
	ProjectSettings.set("display/window/size/resizable", true) #resizable
	ProjectSettings.set("rendering/textures/canvas_textures/default_texture_filter", "Nearest") #for pixel art(makes pixel art much clearer)
	ProjectSettings.set("input", "meow")
	
	ProjectSettings.save() #Save the settings
