extends Node

#Check the Player_Display Control node to see how these are used
var players = [] #holds the amount of players and there corresponding color
var current_player : int #index of the current player, changes upon pressing a grid from cell_spawner script
var previous_player : int :#used to check who was the last player that pressed the spawner
	set(value):
		previous_player = value
		#print(self.name, ">previous_player: ", previous_player)

var registered_players : Array[int] #players who have registered, meaning they've already put their first cell
var players_cell_count : Dictionary #how many cells each registered players have
var amount_of_players_still_in_game : int #amount of players that are still in game

var simulation_playing : bool #True everytime the simulation(chain reaction) is still ongoing
var simulation_time : float : #When reaches zero meaning the simulation is done, for every chain reaction the timer resets
	set(value):
		simulation_time = value
		simulation_playing = true

signal player_change #emit signal everytime the current player has changed
signal game_finished #when there is a winner

func _ready() -> void:
	print(self.name, "> Instantiated")
	GameState.connect("restart", _restart)

func _process(delta: float) -> void:
	if simulation_playing: #If simulation is occuring
		if simulation_time > 0.0:#run simulation until simulation time reaches zero
			simulation_time -= delta #reduces simulation time
		else:#when reaches zero 
			print(self.name, ">Simulation finished")
			simulation_playing = false #simulation is done
			
			for i in players.size(): #Check if there are any more players eliminated after the simulation
				is_player_still_inGame(i)
			emit_signal("player_change") #emit signal incase there are players eliminated
			if amount_of_players_still_in_game == 1: #Check if the amount of players left is 1, meaning that remaining player won
				check_winner()

func reset_simulation_timer():
	simulation_time = 0.2
	#print(self.name, ">Simulation start")

func next_player():
	if players[current_player] != null: #before assigning the new previous player, check if the last player wasn't a null(null means had lost)
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
	#print(self.name, ">Cell Counts> ", players_cell_count)

func is_player_still_inGame(player) -> bool: #run first before a player can put a cell in a spawner
	if players[player] == null:
		return false
	if not registered_players.has(player): #check if this player is not yet registered(player have already put their first cell)
		_register_player(player) #if not registered, register the player by adding it's index in the array 
		return true

	if players_cell_count[player] <= 0:  #meaning the player has no more cells
		print(self.name, ">Player ", player + 1, " Lost!")
		players[player].queue_free()
		players[player] = null
		amount_of_players_still_in_game -= 1
		print(self.name, ">amount_of_players_still_in_game: ", amount_of_players_still_in_game)
		next_player()
		return false

	return true

func _register_player(player : int):
	registered_players.append(player) 
	players_cell_count[player] = 0 #create a dictionary for the player with a starting value of 0
	print(self.name, ">Player ", player + 1, " registered!")
	
	if registered_players.size() == players.size():
		print(self.name, ">all players are registered!")
		amount_of_players_still_in_game = players.size()

func check_winner():
	for player in players.size():
		if player != null:
			print(self.name, ">Player won!: Player ", player + 1)
			emit_signal("game_finished", "Player " + str(player + 1))

func _restart():
	if players != []:
		for player in players:
			if player != null:
				player.queue_free()

	players = [] #holds the amount of players and there corresponding color
	current_player = 0 #index of the current player, changes upon pressing a grid from cell_spawner script
	previous_player = 0 #used to check who was the last player that pressed the spawner

	registered_players = [] #players who have registered, meaning they've already put their first cell
	players_cell_count = {} #how many cells each registered players have
	amount_of_players_still_in_game = 0 #amount of players that are still in game
