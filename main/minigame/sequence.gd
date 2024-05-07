extends Node

class_name Sequence

var label: String
var static_instr: Array[Instruction]
var easy_instr: Array[Instruction]
var medium_instr: Array[Instruction]
var pattern: Array[Instruction]

func _init(
	p_label: String,
	p_static_instr: Array[Instruction],
	p_easy_instr: Array[Instruction],
	p_medium_instr: Array[Instruction],
	p_pattern: Array[Instruction]
):
	label = p_label
	static_instr = p_static_instr
	easy_instr = p_easy_instr
	medium_instr = p_medium_instr
	pattern = p_pattern
