extends Node

var purchased = []

signal added_new_skin

func add_to_inventory(new_skin : CompressedTexture2D):
	print("Skin added to inventory: ", new_skin)
	purchased.append(new_skin)
	
	emit_signal("added_new_skin", new_skin)
