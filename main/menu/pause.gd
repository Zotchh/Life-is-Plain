extends MarginContainer

""" Script for pause menu interactions
	- Handle states on button pressed
"""

signal option_opened()
signal tutorial_opened()

@export var level_node: Node
@export var option_node: MarginContainer
@export var tutorial_node: MarginContainer

@onready var resume_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/ResumeButton
@onready var option_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/OptionButton
@onready var tutorial_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/TutorialButton
@onready var menu_button: Button = $BackgroundMarginContainer/ContentMargin/Content/Buttons/MenuButton

func _ready():
	level_node.pause_opened.connect(_on_pause_opened)
	level_node.pause_closed.connect(_on_pause_closed)
	option_node.option_closed.connect(_on_option_closed)
	tutorial_node.tutorial_closed.connect(_on_tutorial_closed)
	
	resume_button.pressed.connect(_resume_button_pressed)
	option_button.pressed.connect(_option_button_pressed)
	tutorial_button.pressed.connect(_tutorial_button_pressed)
	menu_button.pressed.connect(_menu_button_pressed)

func _process(_delta):
	pass

func _on_pause_opened():
	self.set_visible(true)

func _on_pause_closed():
	self.set_visible(false)

func _on_option_closed():
	self.set_visible(true)

func _on_tutorial_closed():
	self.set_visible(true)

func _resume_button_pressed():
	print("Resume button pressed")
	self.set_visible(false)

func _option_button_pressed():
	print("Option button pressed")
	option_opened.emit()
	self.set_visible(false)

func _tutorial_button_pressed():
	print("Tutorial button pressed")
	tutorial_opened.emit()
	self.set_visible(false)

func _menu_button_pressed():
	print("Menu button pressed")
	get_tree().change_scene_to_file("res://main/menu/menu.tscn")
