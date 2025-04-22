extends Control

func _ready() -> void:
	GameState.connect("restart", _restart)

func _restart():
	_main_menu()
	
func _on_main_menu_visibility_changed() -> void:
	if %MainMenu.visible:
		_main_menu()

func _on_start_pressed() -> void:
	_in_game()

func _on_winner_panel_visibility_changed() -> void:
	if %WinnerPanel.visible:
		_win()
	
func _main_menu():
	%UI.visible = true
	%WinnerPanel.visible = false
	%In_Game_UI.visible = false
	%LOD.visible
	%MainMenu.visible = true

func _in_game():
	%UI.visible = true
	%WinnerPanel.visible = false
	%In_Game_UI.visible = true
	%LOD.visible = false
	%MainMenu.visible = false

func _win():
	%UI.visible = true
	%WinnerPanel.visible = true
	%In_Game_UI.visible = false
	%LOD.visible = true
	%MainMenu.visible = false
	get_tree().paused = true
