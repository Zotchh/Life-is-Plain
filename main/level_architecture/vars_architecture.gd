extends Node

var instructions: Dictionary = {
	"D": Instruction.new("Design", "D", "minigame_d"),
	"E": Instruction.new("Erase", "E", "minigame_e"),
	"P": Instruction.new("Plot", "P", "minigame_p"),
	"M": Instruction.new("Model", "M", "minigame_m"),
	"S": Instruction.new("Sketch", "S", "minigame_s"),
}

var sequences: Array = [
	['S', 'P', 'D', 'E', 'M', 'D', 'P', 'P', 'D', 'S'],
	['D', 'E', 'P', 'P', 'E', 'S', 'P'],
]
