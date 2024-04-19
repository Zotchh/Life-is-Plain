extends Node

class_name Instruction

var instr_name: String
var key_name: String
var key_value: String

func _init(instr_name: String, key_name: String, key_value: String):
	self.instr_name = instr_name
	self.key_name = key_name
	self.key_value = key_value
