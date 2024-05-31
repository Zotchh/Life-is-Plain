extends Node

# Signals
signal minigame_started(minigame: Minigame)
signal minigame_closed()
signal pause_opened()

signal start_resource_timers()
signal start_countdown_timers()

signal map_changed(minigame: Minigame)

# Modulable nodes
@export var pause_node: MarginContainer
@export var lower_HUD: Control
@export var left_HUD: MarginContainer
@export var minigame_interface: MarginContainer

# Child Scenes
@onready var background: ColorRect = $Background
@onready var curr_level: Node2D = $LevelProgramming
@onready var music_game = $music_game

# Variables
var minigames_from_scene: Dictionary

# state flags
var paused: bool = false
var is_minigame_toggled: bool = false

# log flags
var key_logged = true
var states_logged = true

""" Called once when instanciated """
func _ready():
	music_game.play()
	
	init_scores()
	init_signals()
	
	minigames_from_scene = VarsMinigame.minigames_properties
	map_changed.emit(minigames_from_scene.get("LevelProgramming"))
	
	start_resource_timers.emit()
	start_countdown_timers.emit()

""" Init signal values """
func init_signals():
	pause_node.pause_closed.connect(_on_pause_closed)
	lower_HUD.countdown_ended.connect(_on_countdown_ended)
	minigame_interface.minigame_completed.connect(_on_minigame_completed)
	left_HUD.game_ended.connect(_on_countdown_ended)

""" Init score values """
func init_scores():
	Global.score_iq = 0
	Global.perfect_counter = 0
	Global.great_counter = 0
	Global.nice_counter = 0

func _process(_delta):
	# Handle movement between levels
	handle_movement()

""" Called every frame """
func _input(_delta):
	# Check if a minigame is launched
	if Input.is_action_just_released("interact"):
		handle_minigame()
	
	# Check if the game is paused
	if Input.is_action_just_pressed("pause"):
		handle_pause()
		get_viewport().set_input_as_handled()

""" Reset all sequence counters """
func reset_counters():
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		value.key_counter = 0

""" Track if any move is pressed 
	and update counters accordingly
"""
func track_moves_counters():
	for move in Global.possible_moves:
		if Input.is_action_just_pressed(move):
			update_moves_counters(move)

""" Update each destination counters
	- increment a counter if it matches move
	- reset if it does not match
"""
func update_moves_counters(move: String):
	Log.print_if("PRESSED KEY: " + move, key_logged)
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		var counter_before: int = value.key_counter
		Log.print_if("checked key: " + value.dest_keys[value.key_counter], key_logged)
		if value.dest_keys[value.key_counter] == move:
			value.key_counter += 1
		else:
			value.key_counter = 0
		
		Log.print_if(str(counter_before) + " ⇒ " + str(value.key_counter), key_logged)
	Log.print_if("", key_logged)

""" Switch scene once a sequence is complete.
	Reset counter if destination is the current scene
"""
func check_counters_completion():
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		
		# Reset sequence counter if player is in the same scene
		if value.key_counter == Global.MAX_MOVE && key == curr_level.name:
			value.key_counter = 0
		# Otherwise change to destination scene
		# And reset interface
		elif value.key_counter == Global.MAX_MOVE:
			reset_counters()
			map_changed.emit(value)
			var dest_file: String = "res://main/" + value.file_name + "/" + value.file_name + ".tscn"
			var levelScene = load(dest_file).instantiate()
			background.add_sibling(levelScene)
			curr_level.queue_free()
			curr_level = levelScene

""" Handle movement in 2 phases
	- Track if any move is pressed and update each possible counters
	- Then check if a sequence is complete
"""
func handle_movement():
	if !is_minigame_toggled && !paused:
		track_moves_counters()
		check_counters_completion()

""" Handle minigame instanciation in the state diagram """
func handle_minigame():
	if is_minigame_toggled && !paused:
		minigame_closed.emit()
		is_minigame_toggled = !is_minigame_toggled
	elif !is_minigame_toggled && !paused:
		var minigame: Minigame = minigames_from_scene[curr_level.name]
		minigame_started.emit(minigame)
		is_minigame_toggled = !is_minigame_toggled
	print_states()

""" Handle pause instanciation in the state diagram """
func handle_pause():
	pause_opened.emit()
	get_tree().paused = true
	
	paused = !paused
	print_states()

""" Print states diagram for debugging purpose """
func print_states():
	var states: String = ""
	states += "is_minigame_toggled: " + str(is_minigame_toggled) + "\n"
	states += "paused: " + str(paused) + "\n"
	Log.print_if(states, states_logged)

""" Trigger when resume button from pause is pressed """
func _on_pause_closed():
	get_tree().paused = false
	paused = !paused
	print_states()

func _on_countdown_ended():
	get_tree().change_scene_to_file("res://main/menu/score.tscn")

func _on_minigame_completed(_type: MinigameTypes.type, _res: float, _score: int, _rank: String):
	handle_minigame()
	print_states()
