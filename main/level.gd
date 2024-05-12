extends Node

# Signals
signal minigame_started(minigame: Minigame)
signal minigame_closed()

signal pause_opened()
signal pause_closed()

signal tutorial_opened()
signal tutorial_closed()

signal start_resource_timers()
signal stop_resource_timers()

signal map_changed(minigame: Minigame)

@onready var music_game = $music_game

# Child Scenes
@onready var background: ColorRect = $Background
@onready var curr_level: Node2D = $LevelProgramming
@onready var minigame_interface: MarginContainer = $HUD/MinigameInterface
@onready var movement_interface: MarginContainer = $MoveInterface
@onready var resume_button: Button = $Pause/BackgroundMarginContainer/ContentMargin/Content/Buttons/ResumeButton

# Variables
var minigames_from_scene: Dictionary

# state flags
var is_tutorial_toggled: bool = true
var is_pause_toggled: bool = false
var is_minigame_toggled: bool = false
var timers_on: bool = false

# log flags
var key_logged = true
var states_logged = true

""" Called once when instanciated """
func _ready():
	music_game.play()
	resume_button.pressed.connect(_on_resumed)
	minigame_interface.minigame_completed.connect(_on_minigame_completed)
	minigames_from_scene = VarsMinigame.minigames_properties

""" Called every frame """
func _process(_delta):
	# Check if a minigame is launched
	if Input.is_action_just_released("interact"):
		handle_minigame()
	
		# Check if tutorial is opened
	if Input.is_action_just_released("tutorial"):
		handle_tutorial()
	
	# Check if the game is paused
	if Input.is_action_just_released("pause"):
		handle_pause()
	
	# Handle movement between levels
	handle_movement()

""" stops all pausable nodes """
func pause():
	stop_resource_timers.emit()

""" unstops all pausable nodes """
func unpause():
	start_resource_timers.emit()

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
	if !is_minigame_toggled && !is_tutorial_toggled && !is_pause_toggled:
		movement_interface.set_visible(true)
		track_moves_counters()
		check_counters_completion()
	else:
		movement_interface.set_visible(false)

""" Handle minigame instanciation in the state diagram """
func handle_minigame():
	if is_minigame_toggled && !is_tutorial_toggled && !is_pause_toggled:
		minigame_closed.emit()
		is_minigame_toggled = !is_minigame_toggled
	elif !is_minigame_toggled && !is_tutorial_toggled && !is_pause_toggled:
		var minigame: Minigame = minigames_from_scene[curr_level.name]
		minigame_started.emit(minigame)
		is_minigame_toggled = !is_minigame_toggled
	print_states()

""" Handle tutorial instanciation in the state diagram """
func handle_tutorial():
	if is_tutorial_toggled && !is_minigame_toggled && !is_pause_toggled:
		unpause()
		tutorial_closed.emit()
		is_tutorial_toggled = !is_tutorial_toggled
	elif !is_tutorial_toggled && !is_minigame_toggled && !is_pause_toggled:
		pause()
		tutorial_opened.emit()
		is_tutorial_toggled = !is_tutorial_toggled
	print_states()

""" Handle pause instanciation in the state diagram """
func handle_pause():
	if is_pause_toggled && is_tutorial_toggled:
		pause_closed.emit()
		is_pause_toggled = !is_pause_toggled
	elif is_pause_toggled:
		unpause()
		pause_closed.emit()
		is_pause_toggled = !is_pause_toggled
	elif !is_pause_toggled:
		pause()
		pause_opened.emit()
		is_pause_toggled = !is_pause_toggled
	print_states()

""" Print states diagram for debugging purpose """
func print_states():
	var states: String = ""
	states += "is_minigame_toggled: " + str(is_minigame_toggled) + "\n"
	states += "is_pause_toggled: " + str(is_pause_toggled) + "\n"
	states += "is_tutorial_toggled: " + str(is_tutorial_toggled) + "\n"
	Log.print_if(states, states_logged)

""" Trigger when resume button from pause is pressed """
func _on_resumed():
	handle_pause()
	print_states()

func _on_minigame_completed(type: MinigameTypes.type, score: float):
	handle_minigame()
	print_states()
