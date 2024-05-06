extends Node

# Instructions for Programming minigame
var i_header = Instruction.new("Header", "H", "minigame_h", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_name = Instruction.new("Name", "N", "minigame_n", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_constructor = Instruction.new("Constructor", "C", "minigame_c", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_attribute = Instruction.new("Attribute", "A", "minigame_a", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_method = Instruction.new("Method", "M", "minigame_m", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_getter = Instruction.new("Getter", "G", "minigame_g", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_setter = Instruction.new("Setter", "S", "minigame_s", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_body = Instruction.new("Body", "B", "minigame_b", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_return = Instruction.new("Return", "R", "minigame_r", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_parameter = Instruction.new("Parameter", "P", "minigame_p", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")
var i_loop = Instruction.new("Loop", "L", "minigame_l", "res://assets/sprites/icons/mental_icon_atlas_texture.tres")

# Sequences for Programming minigame
var s_class = Sequence.new(
	"class",
	[i_header, i_name, i_constructor],
	[i_attribute, i_method],
	[i_getter, i_setter],
	[i_header, i_name, i_attribute, i_constructor, i_method, i_getter, i_setter]
)
var s_function = Sequence.new(
	"function",
	[i_header, i_name, i_body, i_return],
	[i_parameter],
	[i_loop],
	[i_header, i_name, i_parameter, i_body, i_loop, i_return]
)

# Global array for public access
var sequences: Array = [
	s_class,
	s_function
]
