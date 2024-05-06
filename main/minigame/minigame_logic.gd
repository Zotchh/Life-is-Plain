extends Control

signal minigame_completed(minigame_type: int, score: float)

# Extern link to level node for signals
@export var level_node: Node

# Extern link for data script, set at init_minigame
@onready var data: Node

# Local link to interface parts for display
@onready var preview_title: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/LeftCol/MinigameTitle
@onready var preview_items: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/LeftCol/ItemList
@onready var sequence_title: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/MiddleCol/SequenceInstructions
@onready var sequence_items: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/MiddleCol/ItemList

const SCORE_INCREMENT: float = Global.SCORE_INCREMENT
const SCORE_DECREMENT: float = Global.SCORE_DECREMENT

# Minigame variables
var minigame_type: int
var solution: Array
var seq: Sequence
var score: float

# current instruction text
var instr_idx: int = 0

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
	for instr: Instruction in seq.pattern:
		is_pressed = is_pressed || Input.is_action_just_pressed(instr.key_value)
	
	return is_pressed

""" Handle a minigame step:
	- increment instruction index
	- close minigame if ended
"""
func handle_step():
	if instr_idx < solution.size() - 1:
		instr_idx+= 1
	else:
		var total_score = solution.size() * SCORE_INCREMENT
		var weighted_score = score / total_score
		minigame_completed.emit(minigame_type, weighted_score)
		_on_minigame_closed()

""" Logic for minigame instruction checks """
func check_instruction():
	# Get instruction
	var curr_instr: Instruction = solution[instr_idx]
	var is_key_correct: bool = Input.is_action_just_pressed(curr_instr.key_value)
	
	# append instructions in preview
	if is_key_correct:
		var item_idx: int = preview_items.add_item(curr_instr.label, null, false)
		preview_items.set_item_custom_bg_color(item_idx, Color.GREEN)
		score += SCORE_INCREMENT
		handle_step()
	elif !is_key_correct && is_any_key_pressed():
		var item_idx: int = preview_items.add_item(curr_instr.label, null, false)
		preview_items.set_item_custom_bg_color(item_idx, Color.RED)
		if score >= SCORE_DECREMENT:
			score -= SCORE_DECREMENT
		handle_step()

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

""" Return a or an depending on the label """
func get_article(label: String) -> String:
	var vowels: Array[String] = ["a", "e", "i", "o", "u", "y", "A", "E", "I", "O", "U", "Y"]
	for v in vowels:
		if label.begins_with(v):
			return "an "
	
	return "a "

""" Build the sequence title """
func build_seq_title(label: String) -> String:
	var title: String = "Do "
	title += get_article(label)
	title += label
	title += " using the following pattern"
	
	return title

""" Helper function for reduce """
func sum(accum, number):
	return accum + number

""" Select instr.size() value at random 
	that sum up to at most max_instr and
	associate it to each instruction in args
"""
func setup_fields(args: Dictionary, instr: Array[Instruction], max_instr: int):
	var total_instr = randi_range(1, max_instr)
	var instr_counts = []
	
	for i in instr.size():
		instr_counts.append(randf())
	
	var instr_sum: int = instr_counts.reduce(sum, 0)
	for i in instr_counts.size():
		instr_counts[i] = floori(instr_counts[i] * instr_sum / total_instr)
	
	instr_sum = instr_counts.reduce(sum, 0)
	for i in (total_instr - instr_sum):
		var rand_idx: int = randi_range(0, instr.size() - 1)
		instr_counts[rand_idx] += 1
	
	var idx = 0
	for i in instr:
		args[i] = instr_counts[idx]
		idx += 1

""" Build a solution as a correct sequence of instruction """
func setup_solution(pattern: Array, args: Dictionary):
	solution = []
	for instr: Instruction in pattern:
		if args.has(instr):
			var count: int = args[instr]
			for c in count:
				solution.append(instr)
		else:
			solution.append(instr)

""" Display the sequence title and the sequence items """
func display_sequence(title: String, pattern: Array, args: Dictionary):
	sequence_title.text = title
	for instr: Instruction in pattern:
		if args.has(instr):
			var count: int = args[instr]
			if count > 0:
				sequence_items.add_item(str(count) + " " + instr.label, load(instr.icon), false)
		else:
			sequence_items.add_item(instr.label, load(instr.icon), false)

""" Setup all fields for a minigame instance """
func setup_minigame(i: int, difficulty: int):
	seq = data.sequences[i]
	var seq_title: String = build_seq_title(seq.label)
	var args: Dictionary = {}
	Log.print("selected sequence: " + seq.label)

	if difficulty == Global.difficulty_level.EASY:
		setup_fields(args, seq.easy_instr, Global.EASY_MAX_INSTR)
	if difficulty == Global.difficulty_level.MEDIUM:
		setup_fields(args, seq.easy_instr, Global.EASY_MAX_INSTR)
		setup_fields(args, seq.medium_instr, Global.MEDIUM_MAX_INSTR)
	
	setup_solution(seq.pattern, args)
	display_sequence(seq_title, seq.pattern, args)

""" Called when minigame starts """
func _on_minigame_started(type):
	if !minigame_opened:
		Log.print("minigame started")

		# Determine which data to load
		init_minigame(type)
		# choose a random sequence and setup
		var i: int = randi_range(0, data.sequences.size() - 1)
		setup_minigame(i, Global.difficulty)
		self.set_visible(true)

		is_ready = true
		minigame_opened = true

""" Called when minigame ends """
func _on_minigame_closed():
	if minigame_opened:
		Log.print("minigame closed")
		self.set_visible(false)
		preview_items.clear()
		sequence_items.clear()
		
		solution = []
		seq = null
		instr_idx = 0
		score = 0
		
		is_ready = false
		minigame_opened = false
