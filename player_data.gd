extends Node

#Check the Player_Display Control node to see how these are used
var players = [] #holds the amount of players and there corresponding color
var current_player : int : #index of the current player, changes upon pressing a grid from cell_spawner script
	set(value):
		previous_player = current_player #assign the current player value to the previous player.
		current_player = value #change the current player to the new value
		if current_player > players.size() - 1: #if the value surpasses the players size, go back to 0
			current_player = 0
		emit_signal("player_change")
		
var previous_player : int #used to check who was the last player that pressed the spawner

var players_cell_count : Dictionary #how many cells each registered players have

signal player_change #emit signal everytime the current player has changed

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("players_playing> ", players_cell_count)

func calculate_cell_count(player : int, value : int): #called everytime a cell is added or removed from a player's cell
	if player == -1: #-1 means there is no player
		return
	if not players_cell_count.has(player): #check if this player is not yet registered(player have already put their first cell)
		players_cell_count[player] = 1 #if not registered, register the player by adding it's index in the array 
		print("Player ", player + 1, " registered!")
		return
		
	players_cell_count[player] += value #add or remove a cell to the player's cell count
	print("players_playing> ", players_cell_count)
