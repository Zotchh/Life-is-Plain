extends Node

class_name Minigame

""" Represent a minigame level, composed by:
	- the minigame file name
	- the minigame type
	- the move names for destination
	- the move values for destination, from input map
	- the move counter
"""

var file_name: String
var type: int
var dest_names: Array[String]
var dest_keys: Array[String]
var key_counter: int

""" Called when built """
func _init(
	p_file_name: String, 
	p_type: int, 
	p_dest_names: Array[String], 
	p_dest_keys: Array[String],
	p_key_counter: int
):
	file_name = p_file_name
	type = p_type
	dest_names = p_dest_names
	dest_keys = p_dest_keys
	key_counter = p_key_counter

static func concat_string(arr: Array[String]):
	var str: String = ""
	for s in arr:
		str += s + " "
	
	return str.left(str.length() - 1)
