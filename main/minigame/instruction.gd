extends Node

class_name Instruction

""" Represent an instruction, composed by:
	- its instruction name
	- its key name
	- its key value, the input map action name
"""

var label: String
var key_label: String
var key_value: String
var icon

""" Called when built """
func _init(
	p_label: String,
	p_key_label: String,
	p_key_value: String,
	p_icon
):
	label = p_label
	key_label = p_key_label
	key_value = p_key_value
	icon = p_icon
