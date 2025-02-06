extends Node
class_name State

signal Transitioned

#All functions doesnt have any code since this is only a base for how a State should be implemented
func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
