extends Control

signal minigame_completed(type: MinigameTypes.type, res: float, score: int, rank: String)
signal food_mashed(type: MinigameTypes.type, amount: float)

# Extern link to level node for signals
@export var level_node: Node

# Extern link for data script, set at init_minigame
@onready var data: Node

# Local link to interface parts for display
@onready var background: ColorRect = $BackgroundMarginContainer/Background
@onready var preview_node: VBoxContainer = $MiniGameMarginContainer/OutterHBoxContainer/LeftCol
@onready var preview_title: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/LeftCol/MinigameTitle
@onready var preview_items: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/LeftCol/ItemList
@onready var sequence_tree: VBoxContainer = $MiniGameMarginContainer/OutterHBoxContainer/SequenceCol
@onready var sequence_title: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/SequenceCol/SequenceInstructions
@onready var sequence_items: ItemList = $MiniGameMarginContainer/OutterHBoxContainer/SequenceCol/ItemList
@onready var formula_tree: MarginContainer = $MiniGameMarginContainer/OutterHBoxContainer/FormulaMargin
@onready var formula_title: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/FormulaMargin/FormulaCol/FormulaTitle
@onready var formula_content: RichTextLabel = $MiniGameMarginContainer/OutterHBoxContainer/FormulaMargin/FormulaCol/FormulaContent
@onready var food_node: Control = $MiniGameMarginContainer/FoodNode
@onready var food_image: TextureRect = $MiniGameMarginContainer/FoodNode/FoodTexture
@onready var food_key_icon: TextureRect = $MiniGameMarginContainer/FoodNode/FoodTexture/FoodKeyIcon

@onready var correct = $correct
@onready var uncorrect = $uncorrect
@onready var perfect_sfx = $perfect
@onready var great_sfx = $great
@onready var nice_sfx = $nice

# Minigame variables
var minigame_type: MinigameTypes.type
var solution: Array
var seq: Sequence
var formula: Formula
var instr_idx: int = 0
var curr_food: Food

var correct_count: int = 0
var wrong_count: int = 0

# state flags
var minigame_opened: bool = false
var is_ready: bool = false

""" Called once when instanciated """
func _ready():
	level_node.minigame_started.connect(_on_minigame_started)
	level_node.minigame_closed.connect(_on_minigame_closed)
	
	sequence_tree.hide()
	formula_tree.hide()
	preview_node.hide()
	food_node.hide()

""" Called every frame """
func _process(_delta):
	if is_ready && minigame_type == MinigameTypes.type.FOOD:
		check_food_key()
	elif is_ready:
		check_instruction()

""" Tracks if any possible key is pressed """
func is_any_key_pressed() -> bool:
	var controled_array: Array[Instruction]
	if minigame_type == MinigameTypes.type.PROGRAMMING:
		controled_array = seq.pattern
	if minigame_type == MinigameTypes.type.CHEMISTRY:
		controled_array = formula.pattern
	if minigame_type == MinigameTypes.type.FOOD:
		return false
	
	var is_pressed: bool = false
	for instr: Instruction in controled_array:
		is_pressed = is_pressed || Input.is_action_just_pressed(instr.key_value)
	
	return is_pressed

func compute_rank() -> String:
	if correct_count == solution.size():
		return "perfect"
	if correct_count >= solution.size() - 2 && correct_count < solution.size():
		return "great"
	if correct_count < solution.size() - 2:
		return "nice"
	
	return ""

func play_rank_sfx(rank: String):
	match rank:
		"perfect":
			perfect_sfx.play()
		"great":
			great_sfx.play()
		"nice":
			nice_sfx.play()

func compute_res() -> float:
	var diff_mod = Global.get_diff_modifier()
	var res: float = maxf(correct_count - wrong_count, 1.0)
	res *= Global.SCORE_STEEP
	res = Global.SCORE_INCREASE_MIN * log(res) / Global.SCORE_HEIGHT
	res *= diff_mod
	
	return res

func compute_score(res: float, type: MinigameTypes.type) -> int:
	var resource_mod: float = 1.0
	match type:
		MinigameTypes.type.PROGRAMMING:
			resource_mod = Global.energy_modifier
		MinigameTypes.type.CHEMISTRY:
			resource_mod = Global.mental_modifier
	
	return floori(res * resource_mod)

""" Handle a minigame step:
	- increment instruction index
	- close minigame if ended
"""
func handle_step():
	if instr_idx < solution.size() - 1:
		instr_idx+= 1
	else:
		var rank: String = compute_rank()
		play_rank_sfx(rank)
		var res: float = compute_res()
		var score: int = compute_score(res, minigame_type)
		minigame_completed.emit(minigame_type, res, score, rank)

""" Logic for minigame instruction checks """
func check_instruction():
	# Get instruction
	var curr_instr: Instruction = solution[instr_idx]
	var is_key_correct: bool = Input.is_action_just_pressed(curr_instr.key_value)
	
	# append instructions in preview
	if is_key_correct:
		correct.play()
		correct_count += 1
		var item_idx: int = preview_items.add_item(curr_instr.label, null, false)
		preview_items.set_item_custom_bg_color(item_idx, Color.GREEN)
		handle_step()
	elif !is_key_correct && is_any_key_pressed():
		uncorrect.play()
		wrong_count += 1
		var item_idx: int = preview_items.add_item(curr_instr.label, null, false)
		preview_items.set_item_custom_bg_color(item_idx, Color.RED)
		handle_step()

""" Handle which values to load depending on the minigame """
func init_minigame(minigame: Minigame):
	data = get_node(minigame.file_path)
	background.set_color(minigame.color)
	minigame_type = minigame.type

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
func setup_prog_args(args: Dictionary, instr: Array[Instruction], max_instr: int):
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

""" Build a prog solution as a correct sequence of instruction """
func setup_prog_solution(pattern: Array, args: Dictionary):
	solution = []
	for instr: Instruction in pattern:
		if args.has(instr):
			var count: int = args[instr]
			for c in count:
				solution.append(instr)
		else:
			solution.append(instr)

""" Build a chemistry solution as a correct sequence of instruction """
func setup_chem_solution(pattern: Array, pattern_count: Array):
	solution = []
	for i in pattern.size():
		var count: int = pattern_count[i]
		for c in count:
			solution.append(pattern[i])

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

""" Display the formula title and the formula items """
func display_formula(title: String, pattern: Array, pattern_count: Array):
	formula_title.text = "[center]" + title + "[/center]"
	var formula_string = "[center]"
	for i in pattern.size():
		var count: int = pattern_count[i]
		var instr: Instruction = pattern[i]
		formula_string += instr.key_label
		if count > 1:
			formula_string += str(count)
	formula_content.text = formula_string + "[/center]"

""" Setup all fields for a prog minigame instance """
func setup_prog_minigame(i: int, difficulty: int):
	seq = data.sequences[i]
	var seq_title: String = build_seq_title(seq.label)
	var args: Dictionary = {}
	Log.print("selected sequence: " + seq.label)

	if difficulty == Global.difficulty_level.EASY:
		setup_prog_args(args, seq.easy_instr, Global.EASY_MAX_INSTR)
	if difficulty == Global.difficulty_level.MEDIUM:
		setup_prog_args(args, seq.easy_instr, Global.EASY_MAX_INSTR)
		setup_prog_args(args, seq.medium_instr, Global.MEDIUM_MAX_INSTR)
	
	setup_prog_solution(seq.pattern, args)
	display_sequence(seq_title, seq.pattern, args)

""" Setup all fields for a chemistry minigame instance """
func setup_chem_minigame(i: int, difficulty: int):
	if difficulty == Global.difficulty_level.EASY:
		i -= data.easy_offset
	formula = data.formulas[i]
	Log.print("selected formula: " + formula.label)

	setup_chem_solution(formula.pattern, formula.pattern_count)
	display_formula(formula.label, formula.pattern, formula.pattern_count)

""" Setup all fields for a food minigame instance """
func setup_food_minigame(i: int):
	var random_food: Food = data.foods[i]
	food_image.texture = load(random_food.image)
	food_key_icon.texture = load(random_food.key_icon)
	curr_food = random_food

func check_food_key():
	var is_key_correct: bool = Input.is_action_just_pressed(curr_food.key_value)
	if is_key_correct:
		food_mashed.emit(MinigameTypes.type.FOOD, Global.FOOD_INCREMENT)

""" Called when minigame starts """
func _on_minigame_started(minigame: Minigame):
	if !minigame_opened:
		Log.print("minigame started")

		# Determine which data to load
		init_minigame(minigame)
		# choose a random sequence and setup
		if minigame.type == MinigameTypes.type.PROGRAMMING:
			var i: int = randi_range(0, data.sequences.size() - 1)
			setup_prog_minigame(i, Global.difficulty)
			preview_node.show()
			sequence_tree.show()
		if minigame.type == MinigameTypes.type.CHEMISTRY:
			var i: int = randi_range(0, data.formulas.size() - 1)
			setup_chem_minigame(i, Global.difficulty)
			preview_node.show()
			formula_tree.show()
		if minigame.type == MinigameTypes.type.FOOD:
			var i: int = randi_range(0, data.foods.size() - 1)
			setup_food_minigame(i)
			food_node.show()
		self.show()

		is_ready = true
		minigame_opened = true

""" Called when minigame ends """
func _on_minigame_closed():
	if minigame_opened:
		Log.print("minigame closed")
		self.hide()
		preview_items.clear()
		sequence_items.clear()
		
		sequence_tree.hide()
		formula_tree.hide()
		preview_node.hide()
		food_node.hide()
		
		solution = []
		seq = null
		formula = null
		instr_idx = 0
		correct_count = 0
		wrong_count = 0
		
		is_ready = false
		minigame_opened = false
