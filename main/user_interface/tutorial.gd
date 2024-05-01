extends MarginContainer

# Extern link to level node for signals
@export var level_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	level_node.tutorial_toggled.connect(_on_tutorial_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tutorial_toggled():
	self.set_visible(!self.visible)

