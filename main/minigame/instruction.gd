extends Node

class_name Instruction

""" Represent an instruction, composed by:
	- its instruction name
	- its key name
	- its key value, the input map action name
	- an associated icon given by a path to the resource
"""

var label: String
var key_label: String
var key_value: String
var icon: String

""" Called when built """
func _init(
	p_label: String,
	p_key_label: String,
	p_key_value: String,
	p_icon: String
):
	label = p_label
	key_label = p_key_label
	key_value = p_key_value
	icon = p_icon
