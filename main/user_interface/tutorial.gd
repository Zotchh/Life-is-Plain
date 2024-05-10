extends MarginContainer

# Extern link to level node for signals
@export var level_node: Node
@onready var music_score = $music_score

# Called when the node enters the scene tree for the first time.
func _ready():
	music_score.play()
	level_node.tutorial_opened.connect(_on_tutorial_toggled)
	level_node.tutorial_closed.connect(_on_tutorial_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_tutorial_toggled():
	self.set_visible(!self.visible)

