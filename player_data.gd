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

var registered_players : Array[int] #players who have registered, meaning they've already put their first cell
var players_cell_count : Dictionary #how many cells each registered players have

signal player_change #emit signal everytime the current player has changed

func player_still_inGame(player) -> bool: #run first before a player can put a cell in a spawner
	if not registered_players.has(player): #check if this player is not yet registered(player have already put their first cell)
		registered_players.append(player) #if not registered, register the player by adding it's index in the array 
		players_cell_count[player] = 0 #create a dictionary for the player with a starting value of 0
		print("Player ", player + 1, " registered!")
		return true

	if players_cell_count[player] <= 0: #meaning the player has no more cells
		print("Player ", player + 1, " Lost!")
		return false

	return true

func calculate_cell_count(player : int, value : int): #called everytime a cell is added or removed from a player's cell
	if player == -1: #-1 means there is no player
		return
	
	#if players_cell_count[player] <= 0: #if the player's cell count is zero(reasons like there are no more cells in the grid, or after a pop where that spawner doesn't have any cells)
		#if value >= 1: #if some cell from the pop is added meaning the player is still alive
			#print("Player ", player + 1, " is still in the game")

	players_cell_count[player] += value #add or remove a cell to the player's cell count
	print("Cell Counts> ", players_cell_count)
