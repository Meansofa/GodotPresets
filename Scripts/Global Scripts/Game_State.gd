extends Node

signal restart

func _ready() -> void:
	self.connect("restart", _restart)
	print(self.name, ">Instantiated")

func _restart():
	print(self.name, "> Game Restarted!")
