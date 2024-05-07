extends Node

var res_root: String = "res://assets/sprites/key_icons/"
var easy_offset: int = 0

# Instructions for Programming minigame
var i_hydrogen = Instruction.new("Hydrogen", "H", "minigame_h", res_root + "key_h.tres")
var i_oxygen = Instruction.new("Oxygen", "O", "minigame_o", res_root + "key_o.tres")

# Sequences for Programming minigame
var s_water = Formula.new(
	"water",
	Global.difficulty_level.EASY,
	[i_hydrogen, i_oxygen],
	[i_hydrogen, i_oxygen],
	[1, 2]
)

# Global array for public access
var formulas: Array = [
	s_water
]
