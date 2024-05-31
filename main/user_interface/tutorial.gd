extends MarginContainer

signal tutorial_closed()

@export var pause_node: MarginContainer

@onready var close_button: Button = $BackgroundMarginContainer/TutorialMarginContainer/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	if pause_node != null:
		pause_node.tutorial_opened.connect(_on_tutorial_opened)

	close_button.pressed.connect(_on_tutorial_closed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_tutorial_opened():
	self.set_visible(true)

func _on_tutorial_closed():
	tutorial_closed.emit()
	self.set_visible(false)
