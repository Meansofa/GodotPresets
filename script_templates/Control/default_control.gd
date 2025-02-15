@tool
extends Control

@export_range(0, 1920, 320) var width: int :
	set(value):
		width = value
		size.x = width
@export_range(0, 1080, 180) var height: int :
	set(value):
		height = value
		size.y = height
@export var portrait_mode : bool :
	set(value):
		portrait_mode = value
		if portrait_mode:
			size = Vector2(height, width)
		else:
			size = Vector2(width, height)
