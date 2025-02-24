@tool
extends VBoxContainer

@export var buy_button : Button
@export var cost_label : RichTextLabel
@export var skin_label : RichTextLabel

@export var cost : int :
	set(value):
		cost = value
		_set_cost(value)

@export var skin : CompressedTexture2D :
	set(value):
		skin = value
		if buy_button != null:
			buy_button.icon = skin

@export var skin_name : String :
	set(value):
		skin_name = value
		if skin_label != null:
			skin_label.text = skin_name

func _set_cost(value):
	if cost_label != null:
		cost_label.text = str(cost) + ".00"
	if buy_button != null:
		buy_button.cost = cost
