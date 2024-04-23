extends Node

var instructions: Dictionary = {
	"D": Instruction.new("Division", "D", "minigame_d"),
	"A": Instruction.new("Addition", "A", "minigame_a"),
	"C": Instruction.new("Compute", "C", "minigame_c"),
	"M": Instruction.new("Multiplication", "M", "minigame_m"),
	"S": Instruction.new("Substraction", "S", "minigame_s"),
}

var sequences: Array = [
	['S', 'D', 'D', 'A', 'S', 'C', 'M', 'D', 'D', 'S'],
	['D', 'A', 'D', 'C', 'S', 'S', 'M'],
]
