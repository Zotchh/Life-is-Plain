extends Node2D

# Signals
signal minigame_started(type: int)
signal minigame_closed()

# Scene nodes
@onready var curr_scene: String = get_tree().current_scene.name
@onready var player_node: CharacterBody2D = $Player
@onready var minigame_node: Control = $"../MinigameInterface"

# Constants
const MAX_MOVE: int = 4

# Variables
var log_enabled: bool = true
var is_moving: bool = false
var possible_moves: Array[String] = ["up", "down", "right", "left"]

# TODO: move the dict into another file and autoload
var minigames_from_scene: Dictionary = {
	"LevelProgramming": Minigame.new(
		"level_programming", 
		MinigameTypes.PROGRAMMING,
		["▲", "◀", "▼", "▶"],
		["up", "left", "down", "right"],
		0,
	),
	"LevelChemistry": Minigame.new(
		"level_chemistry",
		MinigameTypes.CHEMISTRY,
		["▼", "▲", "▼", "▲"],
		["down", "up", "down", "up"],
		0,
	),
}

""" Called once when instanciated """
func _ready():
	pass

""" Called every frame """
func _process(_delta):
	# Check if a minigame is launched
	if Input.is_action_just_released("interact"):
		var minigame: Minigame = minigames_from_scene[curr_scene]
		minigame_started.emit(minigame.type)
	
	# Check if a minigame is closed
	if Input.is_action_just_released("close"):
		minigame_closed.emit()
	
	# Handle movement between levels
	handle_movement()

""" Debug logs if enabled """
func _log(x: String):
	if log_enabled:
		Log.print(x)

""" Reset all sequence counters """
func reset_counters():
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		value.key_counter = 0

""" Track if any move is pressed 
	and update counters accordingly
"""
func track_moves_counters():
	for move in possible_moves:
		if Input.is_action_just_pressed(move):
			update_moves_counters(move)

""" Update each destination counters
	- increment a counter if it matches move
	- reset if it does not match
"""
func update_moves_counters(move: String):
	_log("PRESSED KEY: " + move)
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		var counter_before: int = value.key_counter
		_log("checked key: " + value.dest_keys[value.key_counter])
		if value.dest_keys[value.key_counter] == move:
			value.key_counter += 1
		else:
			value.key_counter = 0
		
		_log(str(counter_before) + " ⇒ " + str(value.key_counter))
	_log("")

""" Switch scene once a sequence is complete.
	Reset counter if destination is the current scene
"""
func check_counters_completion():
	for key in minigames_from_scene:
		var value: Minigame = minigames_from_scene[key]
		
		# Reset sequence counter if player is in the same scene
		if value.key_counter == MAX_MOVE && key == curr_scene:
			value.key_counter = 0
		# Otherwise change to destination scene
		elif value.key_counter == MAX_MOVE:
			is_moving = false
			var dest_file: String = "res://main/" + value.file_name + "/" + value.file_name + ".tscn"
			get_tree().change_scene_to_file(dest_file)

""" Handle movement in 2 phases
	- Track if any move is pressed and update each possible counters
	- Then check if a sequence is complete
"""
func handle_movement():
	if Input.is_action_just_pressed("movement"):
		is_moving = !is_moving
	
	if is_moving:
		track_moves_counters()
	else:
		reset_counters()
	
	check_counters_completion()
