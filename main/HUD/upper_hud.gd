extends NinePatchRect

@export var level_node: Node

@onready var level_icon = $LevelIcon
@onready var level_name = $LevelIcon/LevelName

func _ready():
	level_node.map_changed.connect(_on_map_changed)

func _on_map_changed(v: Minigame):
	self_modulate = v.color
	level_icon.texture = load(v.icon_path)
	level_name.text = MinigameTypes.get_dest_name(v.type)
