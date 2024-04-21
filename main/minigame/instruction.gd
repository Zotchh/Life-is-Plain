extends Node

class_name Instruction

""" Represent an instruction, composed by:
	- its instruction name
	- its key name
	- its key value, the input map action name
"""

var instr_name: String
var key_name: String
var key_value: String

""" Called when built """
func _init(p_instr_name: String, p_key_name: String, p_key_value: String):
	instr_name = p_instr_name
	key_name = p_key_name
	key_value = p_key_value
