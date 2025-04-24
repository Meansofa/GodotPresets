extends TileMapLayer

var columns := 0 :
	set(value):
		columns = value
		emit_signal("map_size_changed", columns, rows)
var rows := 0 :
	set(value):
		rows = value
		emit_signal("map_size_changed", columns, rows)

var top_row : int = 0
var bottom_row : int = 0
var left_column : int = 0
var right_column : int = 0

var last_value := -1

signal map_size_changed

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		_add_column()
	if Input.is_action_just_pressed("ui_left"):
		_remove_column()
	if Input.is_action_just_pressed("ui_up"):
		_add_row() 
	if Input.is_action_just_pressed("ui_down"):
		_remove_row()

func _ready() -> void:
	clear_grid()
	#_generate_grid(4, 2)

func clear_grid():
	clear()
	top_row = 0
	bottom_row = 0
	left_column = 0
	right_column = 0
	columns = 0
	rows = 0

func _generate_grid(add_columns : int, add_rows : int):
	for column in range(add_columns):
		_add_column()
	for row in range(add_rows):
		_add_row()
	print("columns: ", columns, " rows: ", rows)

func _add_column(): #add left and right cells
	for row in range(bottom_row): #starts at 0 index
		var bottom_right_pos = Vector2i(right_column, row)
		set_cell(bottom_right_pos, 0, Vector2i(0, 0), 1)
		
		var bottom_left_pos = Vector2i(-left_column - 1, row)
		set_cell(bottom_left_pos, 0, Vector2i(0, 0), 1)
	
	for row in range(top_row + 1): #top row is negative so need to start at -1 hence top_row + 1
		var top_right_pos = Vector2i(right_column, -row)
		set_cell(top_right_pos, 0, Vector2i(0, 0), 1)
		
		var top_left_pos = Vector2i(-left_column - 1, -row)
		set_cell(top_left_pos, 0, Vector2i(0, 0), 1)
	
	right_column += 1
	left_column += 1
	columns += 2

func reload_grid():
	var temp_rows = rows
	var temp_columns = columns
	clear_grid()
	_generate_grid(temp_columns/2, temp_rows/2)
	columns = temp_columns
	rows = temp_rows

func _add_row(): #add top and bottom cells
	for column in range(right_column):  #starts at 0 index
		var bottom_right_pos = Vector2i(column, bottom_row)
		set_cell(bottom_right_pos, 0, Vector2i(0, 0), 1)
		
		var bottom_left_pos = Vector2i(-column - 1, bottom_row)
		set_cell(bottom_left_pos, 0, Vector2i(0, 0), 1)
	
	for column in range(left_column): #left_column is negative so need to start at -1 hence top_row + 1
		var top_right_pos = Vector2i(column, -top_row - 1)
		set_cell(top_right_pos, 0, Vector2i(0, 0), 1)
		
		var top_left_pos = Vector2i(-column - 1, -top_row - 1)
		set_cell(top_left_pos, 0, Vector2i(0, 0), 1)

	top_row += 1
	bottom_row += 1
	rows += 2

func _remove_column():
	right_column -= 1
	left_column -= 1
	columns -= 2
	for row in range(bottom_row): #starts at 0 index
		var bottom_right_pos = Vector2i(right_column, row)
		erase_cell(bottom_right_pos)
		
		var bottom_left_pos = Vector2i(-left_column - 1, row)
		erase_cell(bottom_left_pos)
	
	for row in range(top_row + 1): #top row is negative so need to start at -1 hence top_row + 1
		var top_right_pos = Vector2i(right_column, -row)
		erase_cell(top_right_pos)
		
		var top_left_pos = Vector2i(-left_column - 1, -row)
		erase_cell(top_left_pos)

func _remove_row():
	top_row -= 1
	bottom_row -= 1
	rows -= 2
	for column in range(right_column):  #starts at 0 index
		var bottom_right_pos = Vector2i(column, bottom_row)
		erase_cell(bottom_right_pos)
		
		var bottom_left_pos = Vector2i(-column - 1, bottom_row)
		erase_cell(bottom_left_pos)
		
	for column in range(left_column): #left_column is negative so need to start at -1 hence top_row + 1
		var top_right_pos = Vector2i(column, -top_row - 1)
		erase_cell(top_right_pos)
		
		var top_left_pos = Vector2i(-column - 1, -top_row - 1)
		erase_cell(top_left_pos)

func _on_map_size_value_changed(value: int) -> void:
	#print(self.name, ">value: ", value, " last value: ", last_value)
	if value == last_value:
		return
	clear_grid()
	
	
	var additional_columns : int
	var additional_rows : int
	match value:
		0: 
			additional_columns = 3
			additional_rows = 6
		20:
			additional_columns = 4
			additional_rows = 7
		40:
			additional_columns = 5
			additional_rows = 10
		60:
			additional_columns = 8
			additional_rows = 15
		80:
			additional_columns = 15
			additional_rows = 30
	
	_generate_grid(additional_columns, additional_rows)
	
	last_value = value

func get_available_directions(position : Vector2) -> Array: #called from the spawner for them to check their neighbors

	var tile_map_position = local_to_map(position) #convert the position given to tile map's position type

	#get the position of neighbors
	var left_neighbor = get_neighbor_cell(tile_map_position, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
	var right_neighbor = get_neighbor_cell(tile_map_position, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
	var top_neighbor = get_neighbor_cell(tile_map_position, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	var bottom_neighbor = get_neighbor_cell(tile_map_position, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	
	#check if there are tiles at the neighbor's position(-1 if none, 0 if yes)
	var left_id = get_cell_source_id(left_neighbor)
	var right_id = get_cell_source_id(right_neighbor)
	var top_id = get_cell_source_id(top_neighbor)
	var bottom_id = get_cell_source_id(bottom_neighbor)
	
	var neighbors = [left_id, right_id, top_id, bottom_id] #put the id of neighbors in the dictionary

	var directions = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)] #adjacent  directions, corresponds to: top, bottom, right, left, must match the neighbors dictionary
	var spawner_directions : Array[Vector2] #put here where the spawner will launch its cells when it pops
	for i in neighbors.size():
		if neighbors[i] != -1: #if it is not -1(neighbor doesn't exist)
			spawner_directions.append(directions[i])
	
	return spawner_directions#return the type of spawner based on how many no_neighbors_count
