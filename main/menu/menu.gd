extends Control

""" Script for main menu interactions
	- Load scenes on button pressed
"""

signal option_opened()

func _ready():
	# Retrieve all buttons
	var startButton = get_node("%ButtonListVerticalContainer/StartButton")
	var optionButton = get_node("%ButtonListVerticalContainer/OptionButton")
	var creditButton = get_node("%ButtonListVerticalContainer/CreditButton")
	var quitButton = get_node("%ButtonListVerticalContainer/QuitButton")
	
	# connect to pressed signal
	startButton.pressed.connect(_start_button_pressed)
	optionButton.pressed.connect(_option_button_pressed)
	creditButton.pressed.connect(_credit_button_pressed)
	quitButton.pressed.connect(_quit_button_pressed)

func _process(_delta):
	pass

func _start_button_pressed():
	print("Start button pressed")
	get_tree().change_scene_to_file("res://main/level.tscn")

func _option_button_pressed():
	print("Option button pressed")
	option_opened.emit()

func _credit_button_pressed():
	print("Credit button pressed")

func _quit_button_pressed():
	print("Quit button pressed")
