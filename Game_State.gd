extends Node

signal restart

func _ready() -> void:
	self.connect("restart", _restart)

func _restart():
	print(self.name, "> Game Restarted!")
