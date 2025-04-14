extends Node

#Gameplay Options, options to change your game and make it more exciting. emmited from the checkbutton nodes in MainMenu
var get_a_turn_on_kill : bool #when a player was able to kill a player they get another turn. Code on player_data
var include_unclickable_grids : bool #some grids are unclickable but cells can still pass through. Code on cell_spawner
