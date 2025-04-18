@tool
extends Node2D

#FOR ADS (IGNORE) ========================
@onready var admob = $Admob
var is_initialized : bool = false
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@export var Players := 2 :
	set(value):
		if value <= 2: #2 is the minimum required players
			return
		Players = value
		emit_signal("players_amount_change", Players)

signal players_amount_change

func _ready() -> void:
	admob.initialize()
	print(self.name, "> Instantiated")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _restart():
	get_tree().reload_current_scene()

#FOR ADS (IGNORE) ========================
func _on_admob_initialization_completed(status_data: InitializationStatus) -> void:
	is_initialized = true


func _on_in_game_ui_visibility_changed() -> void:
	if %In_Game_UI.visible:
		_show_top_banner_ad()

func _show_top_banner_ad():
	if is_initialized:
		admob.load_banner_ad()
		await admob.banner_ad_loaded
		admob.show_banner_ad()
