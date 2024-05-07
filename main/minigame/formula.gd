extends Node

class_name Formula

var label: String
var difficulty: Global.difficulty_level
var static_instr: Array[Instruction]
var pattern: Array[Instruction]
var pattern_count: Array[int]

func _init(
	p_label: String,
	p_difficulty: Global.difficulty_level,
	p_static_instr: Array[Instruction],
	p_pattern: Array[Instruction],
	p_pattern_count: Array[int]
):
	label = p_label
	difficulty = p_difficulty
	static_instr = p_static_instr
	pattern = p_pattern
	pattern_count = p_pattern_count
