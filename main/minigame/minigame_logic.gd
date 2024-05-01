extends Control

signal minigame_completed(minigame_type: int, score: float)

# Extern link to level node for signals
@export var level_node: Node
# Extern link for data script, set at init_minigame
@onready var data: Node

# Local link to interface parts for display
@onready var instructions_interface: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/MiddleVBoxContainer/ItemList
@onready var shortcuts_interface: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/RightVBoxContainer/ItemList
@onready var preview_interface: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/LeftVBoxContainer/ItemList

const SCORE_INCREMENT: float = 2
const SCORE_DECREMENT: float = 1

# Minigame variables
var minigame_type: int
var instructions: Dictionary
var sequences: Array
var score: float

# current instruction text
var instr_idx: int = 0
var curr_seq: Array = []

# tracks if minigame is ready to start
var minigame_opened: bool = false
var is_ready: bool = false

""" Called once when instanciated """
func _ready():
	level_node.minigame_started.connect(_on_minigame_started)
	level_node.minigame_closed.connect(_on_minigame_closed)

""" Called every frame """
func _process(_delta):
	if is_ready:
		check_instruction()

""" Tracks if any possible key is pressed """
func is_any_key_pressed() -> bool:
	var is_pressed: bool = false
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
		var total_score = curr_seq.size() * SCORE_INCREMENT
		var weighted_score = score / total_score
		minigame_completed.emit(minigame_type, weighted_score)
		_on_minigame_closed()

""" Logic for minigame instruction checks """
func check_instruction():
	# Get instruction
	var curr_instr: Instruction = instructions[curr_seq[instr_idx]]
	var is_key_correct: bool = Input.is_action_just_pressed(curr_instr.key_value)
	
	# add in green if correct or red if wrong
	if is_key_correct:
		var item_idx: int = preview_interface.add_item(curr_instr.instr_name, null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.GREEN)
		
		score += SCORE_INCREMENT
		
		handle_step()
	elif !is_key_correct && is_any_key_pressed():
		var item_idx: int = preview_interface.add_item(curr_instr.instr_name, null, false)
		preview_interface.set_item_custom_bg_color(item_idx, Color.RED)
		
		if score >= SCORE_DECREMENT:
			score -= SCORE_DECREMENT
		
		handle_step()

""" Return a random sequence index """
func get_random_sequence_index() -> int:
	return randi_range(0, sequences.size() - 1)

""" Handle which values to load depending on the minigame """
func init_minigame(type):
	minigame_type = type
	match type:
		MinigameTypes.PROGRAMMING:
			data = get_node("/root/VarsProgramming")
			$BackgroundMarginContainer/Background.set_color(Color.hex(0x00dd00f0))
		MinigameTypes.CHEMISTRY:
			data = get_node("/root/VarsChemistry")
			$BackgroundMarginContainer/Background.set_color(Color.hex(0xb00510f0))
		MinigameTypes.ARCHITECTURE:
			data = get_node("/root/VarsArchitecture")
			$BackgroundMarginContainer/Background.set_color(Color.hex(0xf6b500f0))
		MinigameTypes.MATH:
			data = get_node("/root/VarsMath")
			$BackgroundMarginContainer/Background.set_color(Color.hex(0x2086d6f0))

""" Called when minigame starts """
func _on_minigame_started(type):
	if !minigame_opened:
		Log.print("minigame started")

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
		var rand_idx: int = get_random_sequence_index()
		curr_seq = sequences[rand_idx]
		instr_idx = 0

		# Append the sequence of instructions
		for key in curr_seq:
			var value: Instruction = instructions[key]
			instructions_interface.add_item(value.instr_name, null, false)

		is_ready = true
		minigame_opened = true
		score = 0

""" Called when minigame ends """
func _on_minigame_closed():
	if minigame_opened:
		Log.print("minigame closed")

		self.set_visible(false)
		instructions_interface.clear()
		shortcuts_interface.clear()
		preview_interface.clear()
		
		instr_idx = 0
		curr_seq = []
		
		is_ready = false
		minigame_opened = false
		score = 0
