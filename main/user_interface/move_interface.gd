extends MarginContainer

# External nodes
@export var level_node: Node

# Internal nodes
@onready var move_items: ItemList = $InnerContainer/InnerVBox/ItemList

# Variables
var minigames: Dictionary

""" Called once when instantiated """
func _ready():
	minigames = VarsMinigame.minigames_properties
	
	for key in minigames:
		var value: Minigame = minigames[key]
		var dest_string: String = MinigameTypes.get_dest_name(value.type)
		var moves_string: String = Minigame.concat_string(value.dest_names)
		var item_idx: int = move_items.add_item(dest_string + ": " + moves_string, null, false)
		move_items.set_item_custom_bg_color(item_idx, value.color)

""" Called each frame """
func _process(_delta):
	pass

func _on_map_opened():
	Log.print("map opened")
	self.set_visible(true)

func _on_map_closed():
	Log.print("map closed")
	self.set_visible(false)