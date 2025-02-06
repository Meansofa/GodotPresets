@tool extends EditorScript

#Auto edit your settings to the ideal Pixel Game Settings
#File > Run 

var editor_variables := EditorVariables.new()

#Note: 640x360 resolution scales well to 720, 1080, and 1440.
func _run() -> void:
	
	editor_variables.viewport_size = Vector2(320, 180) #Size of the viewport
	editor_variables.window_size = Vector2(640, 360) #Size of the window
	
	#Layer Names
	ProjectSettings.set("layer_names/2d_physics/layer_1", "Player")
	ProjectSettings.set("layer_names/2d_physics/layer_2", "Enemies")
	ProjectSettings.set("layer_names/2d_physics/layer_3", "Hazards")
	ProjectSettings.set("layer_names/2d_physics/layer_4", "Environment")
	ProjectSettings.set("layer_names/2d_physics/layer_5", "Coins")
	
	ProjectSettings.set("display/window/stretch/mode", "canvas_items") #for full screen
	ProjectSettings.set("display/window/size/resizable", true) #resizable
	ProjectSettings.set("rendering/textures/canvas_textures/default_texture_filter", "Nearest") #for pixel art(makes pixel art much clearer)
	
	ProjectSettings.save() #Save the settings
