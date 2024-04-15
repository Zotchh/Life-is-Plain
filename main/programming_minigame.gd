extends Control

@onready var instructions_interface = $MiniGameMarginContainer/OutterHBoxContainer/MiddleVBoxContainer/ItemList
@onready var shortcuts_interface = $MiniGameMarginContainer/OutterHBoxContainer/RightVBoxContainer/ItemList
@onready var level_node = $"../Level"

var shortcut_to_instruction: Dictionary
var instructions_pool: Dictionary

var current_instructions = null

func _init():
	shortcut_to_instruction = {
		"I": "if",
		"B": "body",
		"C": "cond",
		"E": "end",
		"V": "variable",
	}
	
	instructions_pool = {
		0: ["if", "cond", "body", "if", "cond", "body", "end", "end"],
		1: ["var", "var", "if", "cond", "body", "end"]
	}
	
func _ready():
	level_node.programming_minigame_started.connect(_on_minigame_started)
	level_node.programming_minigame_closed.connect(_on_minigame_closed)

func _process(_delta):
	pass

func get_random_instructions():
	var random_idx = randi_range(0, instructions_pool.size() - 1)
	current_instructions = instructions_pool[random_idx]

func _on_minigame_started():
	print("programming minigame started")
	for key in shortcut_to_instruction:
		var value = shortcut_to_instruction[key]
		shortcuts_interface.add_item(key + ": " + value, null, false)
	
	get_random_instructions()
	for instr in current_instructions:
		instructions_interface.add_item(instr, null, false)

func _on_minigame_closed():
	print("programming minigame closed")
	instructions_interface.clear()
	shortcuts_interface.clear()
