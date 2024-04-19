extends Control

# Extern link to level node for signals
@export var level_node: Node2D

# Extern link for data script, set at init_minigame
@onready var data

# Local link to interface parts for display
@onready var instructions_interface = $MiniGameMarginContainer/OutterHBoxContainer/MiddleVBoxContainer/ItemList
@onready var shortcuts_interface = $MiniGameMarginContainer/OutterHBoxContainer/RightVBoxContainer/ItemList
@onready var preview_interface = $MiniGameMarginContainer/OutterHBoxContainer/LeftVBoxContainer/PreviewVBoxContainer/ItemList

# Minigame text storage
var instructions: Dictionary
var sequences: Array

# current instruction text
var instr_idx = 0
var curr_seq = null

# tracks if minigame is ready to start
var is_ready = false

""" Called once when instanciated """
func _ready():
	level_node.minigame_started.connect(_on_minigame_started)
	level_node.minigame_closed.connect(_on_minigame_closed)

""" Called every frame """
func _process(_delta):
	if is_ready:
		check_instruction()

""" Tracks if any possible key is pressed """
func is_any_key_pressed():
	var is_pressed = false
	for key in instructions:
		var value: Instruction = instructions[key]
		is_pressed = is_pressed || Input.is_action_just_pressed(value.key_value)
	
	return is_pressed

""" Handle a minigame step:
	- increment instruction index
	- close minigame if ended
"""
func handle_step():
	if instr_idx < curr_seq.size() - 1:
		instr_idx+= 1
	else:
		_on_minigame_closed()

""" Logic for minigame instruction checks """
func check_instruction():
	# Get instruction
	var curr_instr: Instruction = instructions[curr_seq[instr_idx]]
	var is_key_correct = Input.is_action_just_pressed(curr_instr.key_value)
	
	# add in green if correct or red if wrong
	if is_key_correct:
		var item_idx = preview_interface.add_item(curr_instr.instr_name, null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.GREEN)
		
		handle_step()
	elif !is_key_correct && is_any_key_pressed():
		var item_idx = preview_interface.add_item(curr_instr.instr_name, null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.RED)
		
		handle_step()

""" Return a random sequence index """
func get_random_sequence_index():
	var random_idx = randi_range(0, sequences.size() - 1)
	return random_idx

""" Handle which values to load depending on the minigame """
func init_minigame(type):
	match type:
		MinigameTypes.PROGRAMMING:
			data = get_node("/root/VarsProgramming")
		MinigameTypes.CHEMISTRY:
			data = get_node("/root/VarsChemistry")

""" Called when minigame starts """
func _on_minigame_started(type):
	print("programming minigame started")
	
	# Determine which data to load
	init_minigame(type)
	instructions = data.instructions
	sequences = data.sequences
	self.set_visible(true)
	
	# Append all possible instructions with associated shortcut
	for key in instructions:
		var value: Instruction = instructions[key]
		shortcuts_interface.add_item(value.key_name + ": " + value.instr_name, null, false)
	
	# Select a random sequence for minigame
	var rand_idx = get_random_sequence_index()
	curr_seq = sequences[rand_idx]
	instr_idx = 0
	
	# Append the sequence of instructions
	for key in curr_seq:
		var value: Instruction = instructions[key]
		instructions_interface.add_item(value.instr_name, null, false)
	
	is_ready = true

""" Called when minigame ends """
func _on_minigame_closed():
	print("programming minigame closed")
	self.set_visible(false)
	instructions_interface.clear()
	shortcuts_interface.clear()
	preview_interface.clear()
	
	instr_idx = 0
	curr_seq = null
	
	is_ready = false
