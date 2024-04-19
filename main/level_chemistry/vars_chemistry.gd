extends Node

var instructions = {
	"A": Instruction.new("Azote", "A", "minigame_a"),
	"L": Instruction.new("Lithium", "L", "minigame_l"),
	"M": Instruction.new("Mercure", "M", "minigame_m"),
	"N": Instruction.new("Nitrogen", "N", "minigame_n"),
	"S": Instruction.new("Sodium", "S", "minigame_s"),
}

var sequences = [
	["A", "L", "L", "M", "A", "L", "L", "M"],
	["S", "N", "M", "A", "N", "M"],
]
