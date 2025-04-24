extends Node

var Game_Over := true : #To check if the game is on or not(On Menu or any settings)
	set(value):
		Game_Over = value
		if Game_Over == false:
			emit_signal("start")
		print(self.name, ">Game Over: ", Game_Over)

signal start
signal restart

func _ready() -> void:
	self.connect("restart", _restart)
	print(self.name, ">Instantiated")

func _restart():
	print(self.name, "> Game Restarted!")
	GameState.Game_Over = true
