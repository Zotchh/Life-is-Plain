extends Control

@onready var instructions_interface = $MiniGameMarginContainer/OutterHBoxContainer/MiddleVBoxContainer/ItemList
@onready var shortcuts_interface = $MiniGameMarginContainer/OutterHBoxContainer/RightVBoxContainer/ItemList
@onready var preview_interface = $MiniGameMarginContainer/OutterHBoxContainer/LeftVBoxContainer/PreviewVBoxContainer/ItemList
@onready var level_node = $"../Level"

var key_to_instruction: Dictionary
var instructions: Array
var instructions_keys: Array

var instructions_idx = 0
var next_instructions = null

var keys_idx = 0
var next_keys = null

var is_ready = false

func _init():
	key_to_instruction = {
		"I": "if",
		"B": "body",
		"C": "cond",
		"E": "end",
		"V": "variable",
	}
	
	instructions = [
		["if", "cond", "body", "if", "cond", "body", "end", "end"],
		["var", "var", "if", "cond", "body", "end"]
	]
	
	instructions_keys = [
		["minigame-i", "minigame-c", "minigame-b", "minigame-i", "minigame-c", "minigame-b", "minigame-e", "minigame-e"],
		["minigame-v", "minigame-v", "minigame-i", "minigame-c", "minigame-b", "minigame-e"]
	]
	
func _ready():
	level_node.programming_minigame_started.connect(_on_minigame_started)
	level_node.programming_minigame_closed.connect(_on_minigame_closed)

func _process(_delta):
	if is_ready:
		check_instruction()

func check_instruction():
	var next_key = next_keys[keys_idx]
	var is_key_correct = Input.is_action_just_pressed(next_key)
	
	if is_key_correct:
		var item_idx = preview_interface.add_item(next_instructions[keys_idx], null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.GREEN)
		
		if keys_idx < next_instructions.size() - 1:
			keys_idx += 1
		else:
			print("minigame_finished")
			level_node.programming_minigame_closed.emit()
	elif (!is_key_correct &&
		(Input.is_action_just_pressed("minigame-b") ||
		Input.is_action_just_pressed("minigame-c") ||
		Input.is_action_just_pressed("minigame-e") ||
		Input.is_action_just_pressed("minigame-i") ||
		Input.is_action_just_pressed("minigame-v"))):
		var item_idx = preview_interface.add_item(next_instructions[keys_idx], null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.RED)
		if keys_idx < next_instructions.size() - 1:
			keys_idx += 1
		else:
			print("minigame_finished")
			level_node.programming_minigame_closed.emit()
			
	is_key_correct = false

func get_random_instruction_index():
	var random_idx = randi_range(0, instructions.size() - 1)
	return random_idx

func _on_minigame_started():
	print("programming minigame started")
	for key in key_to_instruction:
		var value = key_to_instruction[key]
		shortcuts_interface.add_item(key + ": " + value, null, false)
	
	instructions_idx = get_random_instruction_index()
	next_instructions = instructions[instructions_idx]
	next_keys = instructions_keys[instructions_idx]
	for instr in next_instructions:
		instructions_interface.add_item(instr, null, false)
	
	is_ready = true

func _on_minigame_closed():
	print("programming minigame closed")
	self.set_visible(false)
	instructions_interface.clear()
	shortcuts_interface.clear()
	preview_interface.clear()
	
	instructions_idx = 0
	next_instructions = null
	
	keys_idx = 0
	next_keys = null
	
	is_ready = false
