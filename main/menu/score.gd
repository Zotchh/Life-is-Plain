extends Control

""" Script for score interactions
	- Load scenes on button pressed
"""

@onready var score_music: AudioStreamPlayer2D = $menu_music

signal option_opened()

func _ready():
	score_music.play()
	# Retrieve all buttons
	var startButton = get_node("%ButtonListVerticalContainer/StartButton")
	var optionButton = get_node("%ButtonListVerticalContainer/OptionButton")
	var menuButton = get_node("%ButtonListVerticalContainer/MenuButton")
	
	# connect to pressed signal
	startButton.pressed.connect(_start_button_pressed)
	optionButton.pressed.connect(_option_button_pressed)
	menuButton.pressed.connect(_menu_button_pressed)

func _process(_delta):
	pass

func _start_button_pressed():
	print("Start button pressed")
	get_tree().change_scene_to_file("res://main/level.tscn")

func _option_button_pressed():
	print("Option button pressed")
	option_opened.emit()

func _menu_button_pressed():
	print("Quit button pressed")
	get_tree().change_scene_to_file("res://main/menu/menu.tscn")
