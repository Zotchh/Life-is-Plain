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
	move_items.clear()
	
	for key in minigames:
		var value: Minigame = minigames[key]
		var item_idx: int = add_move(value)
		if value.type == MinigameTypes.type.PROGRAMMING:
			move_items.set_item_custom_bg_color(item_idx, Color.TRANSPARENT)
			move_items.select(item_idx)

""" Called each frame """
func _process(_delta):
	pass

""" Set minigame values for movement interface """
func add_move(v: Minigame) -> int:
	var dest_string: String = MinigameTypes.get_dest_name(v.type)
	var moves_string: String = Minigame.concat_string(v.dest_names)
	var item_idx: int = move_items.add_item(moves_string, load(v.icon_path), true)
	move_items.set_item_custom_bg_color(item_idx, v.color)
	
	return item_idx

func _on_map_changed(minigame: Minigame):
	Log.print("map changed")
	move_items.clear()
	for key in minigames:
		var value: Minigame = minigames[key]
		var item_idx: int = add_move(value)
		if value.type == minigame.type:
			move_items.set_item_custom_bg_color(item_idx, Color.TRANSPARENT)
			move_items.select(item_idx)
