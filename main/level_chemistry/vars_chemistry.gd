extends Node

var res_root: String = "res://assets/sprites/key_icons/"
var easy_offset: int = 0

# Instructions for Programming minigame
var i_hydrogen = Instruction.new("Hydrogen", "H", "minigame_h", res_root + "key_h.tres")
var i_oxygen = Instruction.new("Oxygen", "O", "minigame_o", res_root + "key_o.tres")
var i_carbon = Instruction.new("Carbon", "C", "minigame_c", res_root + "key_c.tres")
var i_sulfur = Instruction.new("Sulfur", "S", "minigame_s", res_root + "key_s.tres")
var i_nitrogen = Instruction.new("Nitrogen", "N", "minigame_n", res_root + "key_n.tres")

# Sequences for Programming minigame
var f_water = Formula.new(
	"WATER",
	Global.difficulty_level.EASY,
	[i_hydrogen, i_oxygen],
	[i_hydrogen, i_oxygen],
	[2, 1]
)
var f_dioxygen = Formula.new(
	"DIOXYGEN",
	Global.difficulty_level.EASY,
	[i_oxygen],
	[i_oxygen],
	[2]
)

var f_sulfur = Formula.new(
	"SULFUR",
	Global.difficulty_level.EASY,
	[i_sulfur],
	[i_sulfur],
	[8]
)
var f_methane = Formula.new(
	"METHANE",
	Global.difficulty_level.EASY,
	[i_carbon, i_hydrogen],
	[i_carbon, i_hydrogen],
	[1, 4]
)

var f_ammonia = Formula.new(
	"AMMONIA",
	Global.difficulty_level.EASY,
	[i_nitrogen, i_hydrogen],
	[i_nitrogen, i_hydrogen],
	[1, 3]
)

var f_sulfuric_acid = Formula.new(
	"SULFURIC ACID",
	Global.difficulty_level.MEDIUM,
	[i_hydrogen, i_sulfur, i_oxygen],
	[i_hydrogen, i_sulfur, i_oxygen],
	[2, 1, 4]
)

var f_caffeine = Formula.new(
	"CAFFEINE",
	Global.difficulty_level.MEDIUM,
	[i_carbon, i_hydrogen, i_nitrogen, i_oxygen],
	[i_carbon, i_hydrogen, i_nitrogen, i_oxygen],
	[8, 10, 4, 2]
)

var f_acetic_acid = Formula.new(
	"ACETIC ACID",
	Global.difficulty_level.MEDIUM,
	[i_carbon, i_hydrogen, i_carbon, i_oxygen, i_oxygen, i_hydrogen],
	[i_carbon, i_hydrogen, i_carbon, i_oxygen, i_oxygen, i_hydrogen],
	[1, 3, 1, 1, 1, 1]
)

# Global array for public access
var formulas: Array = [
	f_water, f_dioxygen, f_sulfur, f_ammonia, f_methane, f_sulfuric_acid, f_caffeine, f_acetic_acid
]
