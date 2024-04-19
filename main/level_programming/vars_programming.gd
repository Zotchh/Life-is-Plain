extends Node

var instructions = {
	"B": Instruction.new("Body", "B", "minigame_b"),
	"C": Instruction.new("Cond", "C", "minigame_c"),
	"E": Instruction.new("End", "E", "minigame_e"),
	"I": Instruction.new("If", "I", "minigame_i"),
	"V": Instruction.new("Variable", "V", "minigame_v"),
}

var sequences = [
	["I", "C", "B", "I", "C", "B", "E", "E"],
	["V", "V", "I", "C", "B", "E"],
]
