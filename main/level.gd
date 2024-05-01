extends Node

# Signals
signal minigame_started(type: int)
signal minigame_closed()

signal tutorial_toggled()

signal map_opened()
signal map_closed()

signal start_resource_timers()
signal stop_resource_timers()

# Child Scenes
@onready var background: ColorRect = $Background
@onready var curr_level: Node2D = $LevelProgramming
@onready var minigame_interface: Control = $HUD/MinigameInterface

# Constants
const MAX_MOVE: int = 4

# Variables
var log_enabled: bool = true
var is_moving: bool = false
var is_minigame_opened: bool = false
var is_tutorial_opened: bool = true
var possible_moves: Array[String] = ["up", "down", "right", "left"]
var minigames_from_scene: Dictionary


var timers_on: bool = false

""" Called once when instanciated """
func _ready():
	minigames_from_scene = VarsMinigame.minigames_properties

""" Called every frame """
func _process(_delta):
	if minigame_interface.visible:
		is_minigame_opened = true
	else:
		is_minigame_opened = false
	
	# Check if a minigame is launched
	if Input.is_action_just_released("interact") && !is_moving:
		var minigame: Minigame = minigames_from_scene[curr_level.name]
		minigame_started.emit(minigame.type)
	
	# Check if a minigame is closed
	if Input.is_action_just_released("close"):
		minigame_closed.emit()
		
	# Check if a minigame is closed
	if Input.is_action_just_released("tutorial"):
		is_tutorial_opened = !is_tutorial_opened
		tutorial_toggled.emit()
	
	
	if Input.is_action_just_released("start"):
		if timers_on:
			stop_resource_timers.emit()
			timers_on = false
		else:
			start_resource_timers.emit()
			timers_on = true
		
	
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
		if value.key_counter == MAX_MOVE && key == curr_level.name:
			value.key_counter = 0
		# Otherwise change to destination scene
		# And reset interface
		elif value.key_counter == MAX_MOVE:
			is_moving = false
			map_closed.emit()
			
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
	if Input.is_action_just_pressed("movement") && !is_minigame_opened:
		if is_moving:
			map_closed.emit()
		else:
			map_opened.emit()
		
		is_moving = !is_moving
	
	if is_moving:
		track_moves_counters()
	else:
		reset_counters()
	
	check_counters_completion()
