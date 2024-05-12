extends MarginContainer

# External nodes
@export var level_node: Node

# Internal nodes
@onready var move_items: ItemList = $MoveMargin/MapContainer/MapItems

# Variables
var minigames: Dictionary

""" Called once when instantiated """
func _ready():
	level_node.map_changed.connect(_on_map_changed)
	minigames = VarsMinigame.minigames_properties
	
	for key in minigames:
		var value: Minigame = minigames[key]
		if value.type != MinigameTypes.type.PROGRAMMING:
			add_move(value)

""" Called each frame """
func _process(_delta):
	pass

""" Set minigame values for movement interface """
func add_move(v: Minigame):
	var dest_string: String = MinigameTypes.get_dest_name(v.type)
	var moves_string: String = Minigame.concat_string(v.dest_names)
	var item_idx: int = move_items.add_item(dest_string + ": " + moves_string, null, false)
	move_items.set_item_custom_bg_color(item_idx, v.color)

func _on_map_changed(minigame: Minigame):
	Log.print("map changed")
	move_items.clear()
	for key in minigames:
		var value: Minigame = minigames[key]
		if value.type != minigame.type:
			add_move(value)
