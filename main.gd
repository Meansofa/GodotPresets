@tool
extends Node2D

@export var Players := 2 :
	set(value):
		if value <= 2: #2 is the minimum required players
			return
		Players = value
		print("asdasd")
		emit_signal("players_amount_change", Players)

signal players_amount_change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.name, "> Instantiated")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _restart():
	get_tree().reload_current_scene()
