extends MarginContainer

""" Script for pause menu interactions
	- Handle states on button pressed
"""

signal pause_closed()
signal option_opened()
signal tutorial_opened()

@export var level_node: Node
@export var option_node: MarginContainer
@export var tutorial_node: MarginContainer

@onready var resume_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/ResumeButton
@onready var option_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/OptionButton
@onready var tutorial_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/TutorialButton
@onready var menu_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/MenuButton

var unpausable: bool = false

func _ready():
	level_node.pause_opened.connect(_on_pause_opened)
	option_node.option_closed.connect(_on_option_closed)
	tutorial_node.tutorial_closed.connect(_on_tutorial_closed)
	
	resume_button.pressed.connect(_resume_button_pressed)
	option_button.pressed.connect(_option_button_pressed)
	tutorial_button.pressed.connect(_tutorial_button_pressed)
	menu_button.pressed.connect(_menu_button_pressed)

func _input(_delta):
	if Input.is_action_just_pressed("pause"):
		_resume_button_pressed()
		get_viewport().set_input_as_handled()

func _on_pause_opened():
	unpausable = false
	show()

func _on_option_closed():
	unpausable = false
	show()

func _on_tutorial_closed():
	unpausable = false
	show()

func _resume_button_pressed():
	if !unpausable:
		pause_closed.emit()
		hide()
		unpausable = false

func _option_button_pressed():
	unpausable = true
	option_opened.emit()
	hide()

func _tutorial_button_pressed():
	unpausable = true
	tutorial_opened.emit()
	hide()

func _menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main/menu/menu.tscn")
