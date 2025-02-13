extends Node

#Check the Player_Display Control node to see how these are used
var players = [] #holds the amount of players and there corresponding color
var current_player : int #index of the current player, changes upon pressing a grid from cell_spawner script
var previous_player : int #used to check who was the last player that pressed the spawner

var registered_players : Array[int] #players who have registered, meaning they've already put their first cell
var players_registered : bool

var players_cell_count : Dictionary #how many cells each registered players have

signal player_change #emit signal everytime the current player has changed

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("players: ", players)
		emit_signal("player_change")

func next_player():
	previous_player = current_player #assign the current player value to the previous player.
	current_player += 1 #change the current player to the new value
	if current_player > players.size() - 1: #if the value surpasses the players size, go back to 0
		current_player = 0
	while players[current_player] == null:
		current_player += 1
		if current_player > players.size() - 1: #if the value surpasses the players size, go back to 0
			current_player = 0

	emit_signal("player_change")

func calculate_cell_count(player : int, value : int): #called everytime a cell is added or removed from a player's cell
	if player == -1: #-1 means there is no player
		return

	players_cell_count[player] += value #add or remove a cell to the player's cell count
	print("Cell Counts> ", players_cell_count)

func player_still_inGame(player) -> bool: #run first before a player can put a cell in a spawner
	if not registered_players.has(player): #check if this player is not yet registered(player have already put their first cell)
		_register_player(player) #if not registered, register the player by adding it's index in the array 
		return true

	if players_cell_count[player] <= 0:  #meaning the player has no more cells
		print("Player ", player + 1, " Lost!")
		players[player] = null
		next_player()
		return false

	return true

func _register_player(player : int):
	registered_players.append(player) 
	players_cell_count[player] = 0 #create a dictionary for the player with a starting value of 0
	print("Player ", player + 1, " registered!")
	
	if registered_players.size() == players.size():
		players_registered = true
		print("all players are registered!")
