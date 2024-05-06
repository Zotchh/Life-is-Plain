extends Node

class_name Minigame

""" Represent a minigame level, composed by:
	- the minigame file name
	- the minigame type
	- the move names for destination
	- the move values for destination, from input map
	- the move counter
	- the move color hexcode
	- the resource path for the minigame icon
	- the title for display purpose
"""

var file_name: String
var file_path: String
var type: int
var dest_names: Array[String]
var dest_keys: Array[String]
var key_counter: int
var color: Color
var icon_path: String
var title: String

""" Called when built """
func _init(
	p_file_name: String,
	p_file_path: String,
	p_type: int, 
	p_dest_names: Array[String], 
	p_dest_keys: Array[String],
	p_key_counter: int,
	p_color: Color,
	p_icon_path: String,
	p_title
):
	file_name = p_file_name
	file_path = p_file_path
	type = p_type
	dest_names = p_dest_names
	dest_keys = p_dest_keys
	key_counter = p_key_counter
	color = p_color
	icon_path = p_icon_path
	title = p_title

static func concat_string(arr: Array[String]):
	var ss: String = ""
	for s in arr:
		ss += s + " "
	
	return ss.left(ss.length() - 1)
