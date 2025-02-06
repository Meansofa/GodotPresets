@tool 
extends PanelContainer

@export var textLabel : RichTextLabel
@export var FillViewport : bool :
	set(value):
		if Engine.is_editor_hint():
			FillViewport = value
			if FillViewport:
				_change_size(Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height")/ 2))
				FillViewport = false
			else:
				_change_size(Vector2(160, 80))

func _change_size(new_size : Vector2):
	print("Size changed: ", new_size)
	size = new_size
	position = Vector2(0, new_size.y)
