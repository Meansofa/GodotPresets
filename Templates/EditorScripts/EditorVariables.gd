@tool
extends EditorScript
class_name EditorVariables

# Game resolution size
#Note: 640x360 resolution scales well to 720, 1080, and 1440.
var viewport_size := Vector2(640, 360) :
	set(value):
		print("Viewport Changed")
		viewport_size = value
		ProjectSettings.set("display/window/size/viewport_width", viewport_size.x)
		ProjectSettings.set("display/window/size/viewport_height", viewport_size.y)
	get:
		return viewport_size

# Editor window size (for debugging)
var window_size := Vector2(640, 360) :
	set(value):
		print("Window Changed")
		window_size = value
		ProjectSettings.set("display/window/size/window_width_override", window_size.x)
		ProjectSettings.set("display/window/size/window_height_override", window_size.y)
	get:
		return window_size

func _run() -> void:
	viewport_size = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height"))
	window_size = Vector2(ProjectSettings.get("display/window/size/window_height/window_width_override"), ProjectSettings.get("display/window/size/window_height/window_height_override"))
