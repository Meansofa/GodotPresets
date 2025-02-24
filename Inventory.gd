extends Node

var purchased = []

var coins : int :
	set(value):
		coins = value
		print(self.name, "> Coins: ", coins)
		emit_signal("coin_changed", coins)

signal added_new_skin
signal coin_changed

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		coins = 1000

func add_to_inventory(new_skin : CompressedTexture2D):
	print("Skin added to inventory: ", new_skin)
	purchased.append(new_skin)
	
	emit_signal("added_new_skin", new_skin)
