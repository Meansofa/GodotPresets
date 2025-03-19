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
		if simulation_time > 0:
			simulation_playing = true
var simulation_total_time : float

signal player_change #emit signal everytime the current player has changed
signal game_finished #when there is a winner
signal player_count_changed #emitted when the amount of players when choosing how many players to play changes

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_9):
		print(self.name, ">KEY_9 pressed")
		check_eliminations()
	if Input.is_key_pressed(KEY_8):
		print(self.name, ">KEY_8 pressed")
		_print_datas()

func _ready() -> void:
	print(self.name, "> Instantiated")
	GameState.connect("restart", _restart)
	GameState.connect("start", clear_cells)

func _process(delta: float) -> void:
	if GameState.Game_Over:
		return
	if simulation_playing: #If simulation is occuring
		if simulation_time > 0.0:#run simulation until simulation time reaches zero
			simulation_time -= delta #reduces simulation time
			simulation_total_time += delta
			if simulation_total_time > 3: #if you think that the simulation is taking so long, check if it's been going on a loop and there is already a winner
				check_eliminations()

		else:#when reaches zero 
			print("WHY")
			print(self.name, ">Simulation finished")
			simulation_playing = false #simulation is done

			check_eliminations()
			
func cell_was_popped(): #called when a cell was popped
	reset_simulation_timer()

func reset_simulation_timer(): #the board is still simulating and  player can't intervene yet
	simulation_time = 0.2
	#print(self.name, ">Simulation start")

func check_eliminations():
	print(self.name, ">simulation_total_time: ", simulation_total_time)
	
	for i in players.size(): #Check if there are any more players eliminated after the simulation
		is_player_still_inGame(i)
	emit_signal("player_change") #emit signal incase there are players eliminated
	if amount_of_players_still_in_game == 1: #Check if the amount of players left is 1, meaning that remaining player won
		check_winner()
	
	simulation_total_time = 0.0

func add_player(player):
	players.append(player)
	emit_signal("player_count_changed")

func reduce_player():
	PlayerData.players.pop_back().queue_free()
	emit_signal("player_count_changed")

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

func calculate_cell_count(player : int, value : int): #called everytime a cell is added or removed from a player's cell. 
	#player is the index value while value is the amount of cell to be added or removed
	if player == -1: #-1 means there is no player
		return
	
	if player >= 0 and player < players_cell_count.size():
		players_cell_count[player] += value #add or remove a cell to the player's cell count
	#print(self.name, ">Cell Counts> ", players_cell_count)

func is_player_still_inGame(player) -> bool: #run first before a player can put a cell in a spawner
	print(self.name, ">player: ", player)
	if players[player] == null:
		return false
	
	print(self.name, ">registered_players: ", registered_players)
	if not registered_players.has(player): #check if this player is not yet registered(player have already put their first cell)
		_register_player(player) #if not registered, register the player by adding it's index in the array 
		return true
	
	print(self.name, ">registered_players2: ", registered_players)
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
	print(self.name, ">check_winner")
	for player in players.size():
		#if index >= 0 and index < my_array.size()
		if player != null and players_cell_count[player] != 0:
			print(self.name, ">Player won!: Player ", player + 1, " with ", players_cell_count[player], " cells!")
			emit_signal("game_finished", "Player " + str(player + 1))

func _restart():
	print(self.name, ">_restart")
	_print_datas()
	
	if players != []: #remove all players from the players array
		for player in players:
			if player != null:
				player.queue_free() #delete them before erasing the array
	
	clear_cells()
	players = [] #holds the amount of players and there corresponding color, no values on restart
	current_player = 0 #index of the current player, changes upon pressing a grid from cell_spawner script
	previous_player = 0 #used to check who was the last player that pressed the spawner

	registered_players = [] #players who have registered, meaning they've already put their first cell
	players_cell_count = {} #how many cells each registered players have
	amount_of_players_still_in_game = 0 #amount of players that are still in game
	simulation_playing = false
	simulation_time = 0
	simulation_total_time = 0 
	
	_print_datas()

func clear_cells():
	var Cells = get_tree().get_nodes_in_group("Cell") #Erase all cells by calling all Cell group
	for cell in Cells:
		cell.queue_free()

func _print_datas():
	print(self.name, ">players: ", players, " current_player: ", current_player, " previous_player: ", previous_player, " registered_players: ", registered_players, " players_cell_count: ", players_cell_count, " amount_of_players_still_in_game: ", amount_of_players_still_in_game, " simulation_total_time: ", simulation_total_time, " simulation_playing: ", simulation_playing, " simulation_time: ", simulation_time)
 
#RESTART BUTTON
#PlayerData>_restart
#PlayerData>players: [<null>, Player 2:<TextureRect#44761613916>] current_player: 1 previous_player: 1 registered_players: [0, 1] players_cell_count: { 0: 0, 1: 78 } amount_of_players_still_in_game: 1 simulation_total_time: 0.0 simulation_playing: true simulation_time: 0.14579044444444
#PlayerData>players: [] current_player: 0 previous_player: 0 registered_players: [] players_cell_count: {  } amount_of_players_still_in_game: 0 simulation_total_time: 0.0 simulation_playing: false simulation_time: 0.0
#GameState> Game Restarted!
#Player_Display> Players Amount: 2
#START BUTTON
#@Button@135>spawner_owner: -1
#PlayerData>player: 0
#PlayerData>registered_players: []
#PlayerData>Player 1 registered!
#@Button@135>spawner_owner2: 0
#@Button@31>spawner_owner: -1
#PlayerData>player: 1
#PlayerData>registered_players: [0]
#PlayerData>Player 2 registered!
#PlayerData>all players are registered!
