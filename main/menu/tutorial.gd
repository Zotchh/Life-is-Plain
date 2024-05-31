extends MarginContainer

signal tutorial_closed()

@export var pause_node: MarginContainer

@onready var close_button: Button = $BackgroundMarginContainer/TutorialMarginContainer/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if pause_node != null:
		pause_node.tutorial_opened.connect(_on_tutorial_opened)

	close_button.pressed.connect(_on_tutorial_closed)

func _input(_delta):
	if Input.is_action_just_pressed("pause") && is_visible_in_tree():
		_on_tutorial_closed()
		get_viewport().set_input_as_handled()

func _on_tutorial_opened():
	self.set_visible(true)

func _on_tutorial_closed():
	tutorial_closed.emit()
	self.set_visible(false)
