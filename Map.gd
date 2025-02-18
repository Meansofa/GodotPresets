extends TileMapLayer

var default_column_size := 8
var default_row_size := 4
var columns := 8 #10
var rows := 4 #5
var added_columns := 0
var added_rows := 0

var default_size := Vector2(8, 4)
var last_value : int

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		_add_columns(1)
	if Input.is_action_just_pressed("ui_down"):
		_add_rows(1)
	if Input.is_action_just_pressed("ui_accept"):
		_remove_columns(1)

func _ready() -> void:
	_generate_grid()
	pass

func _generate_grid():
	for column in columns:
		for row in rows:
			var pos := Vector2i(column + 1, row + 1)
			set_cell(pos, 0, Vector2i(0, 0), 1)

func _add_columns(additional_columns : int):
	for column in additional_columns:
		columns += 1
		for row in rows:
			var pos := Vector2i(columns, row + 1)
			set_cell(pos, 0, Vector2i(0, 0), 1)
	print(self.name, ">columns: ", columns)

func _add_rows(additional_rows : int):
	for row in additional_rows:
		rows += 1
		for column in columns:
			var pos := Vector2i(column + 1, rows)
			set_cell(pos, 0, Vector2i(0, 0), 1)
	print(self.name, ">rows: ", rows)

func _remove_rows(removed_rows : int):
	if rows <= 0:
		return
	for row in removed_rows:
		for column in columns:
			var pos := Vector2i(column + 1, rows)
			erase_cell(pos)
		rows -= 1
	print(self.name, ">rows: ", rows)

func _remove_columns(removed_columns : int):
	if columns <= 0:
		return
	for column in removed_columns:
		for row in rows:
			var pos := Vector2i(columns, row + 1)
			erase_cell(pos)
		columns -= 1
	print(self.name, ">columns: ", columns)

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


func _on_h_slider_value_changed(value: float) -> void:
	print("value: ", value)
	var additional_columns = ceili(value / 100 * default_column_size) - added_columns
	added_columns += additional_columns
	print("additional_columns: ", additional_columns)
	var additional_rows = ceili(value / 100 * default_row_size) - added_rows
	added_rows += additional_rows
	print("additional_rows: ", additional_rows)
	if additional_columns > 0:
		_add_columns(additional_columns)
	if additional_rows > 0:
		_add_rows(additional_rows)
	pass


func _on_map_size_value_changed(value: float) -> void:
	if value > last_value:
		position += Vector2(value, value)
		var additional_columns = ceili(value / 100.0 * default_column_size)
		_add_columns(additional_columns)
		var additional_rows = ceili(value / 100.0 * default_row_size)
		_add_rows(additional_rows)
	if value < last_value:
		position -= Vector2(last_value, last_value)
		var additional_columns = ceili(last_value / 100.0 * default_column_size)
		_remove_columns(additional_columns)
		var additional_rows = ceili(last_value / 100.0 * default_row_size)
		_remove_rows(additional_rows)
	if value != last_value:
		last_value = value
	
	print(self.name, "Map Size: ", position)
