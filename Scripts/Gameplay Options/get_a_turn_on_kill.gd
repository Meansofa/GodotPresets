extends CheckButton


func _on_toggled(toggled_on: bool) -> void:
	GameplayOptions.get_a_turn_on_kill = toggled_on
	print("get_a_turn_on_kill: ", toggled_on)
