extends Node

var players = [] #holds the amount of players and there corresponding color, received from $Control/Player_Display
var current_player : int : #index of the current player, changes upon pressing a grid from cell_spawner script
	set(value):
		previous_player = current_player #assign the current player value to the previous player.
		current_player = value #change the current player to the new value
		if current_player > players.size() - 1: #if the value surpasses the players size, go back to 0
			current_player = 0
var previous_player : int #used to check who was the last player that pressed the spawner
