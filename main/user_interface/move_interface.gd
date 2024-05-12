extends MarginContainer

# External nodes
@export var level_node: Node
@export var minigame_node: MarginContainer

# Internal nodes
@onready var move_items: ItemList = $MoveMargin/MapContainer/MapItems
@onready var iq_node: RichTextLabel = $MoveMargin/ScoreContainer/ScoreInner/ScoreValue/IQValue
@onready var perfect_node: RichTextLabel = $MoveMargin/ScoreContainer/ScoreInner/ScoreValue/PerfectValue
@onready var great_node: RichTextLabel = $MoveMargin/ScoreContainer/ScoreInner/ScoreValue/GreatValue
@onready var nice_node: RichTextLabel = $MoveMargin/ScoreContainer/ScoreInner/ScoreValue/NiceValue

# Variables
var minigames: Dictionary

""" Called once when instantiated """
func _ready():
	level_node.map_changed.connect(_on_map_changed)
	minigame_node.minigame_completed.connect(_on_minigame_completed)
	minigames = VarsMinigame.minigames_properties
	move_items.clear()
	
	for key in minigames:
		var value: Minigame = minigames[key]
		var item_idx: int = add_move(value)
		if value.type == MinigameTypes.type.PROGRAMMING:
			move_items.set_item_custom_bg_color(item_idx, Color.TRANSPARENT)
			move_items.select(item_idx)
	
	iq_node.text = "[right][color=white]" + str(0) + "[/color][/right]"
	perfect_node.text = "[right][color=gold]" + str(0) + "[/color][/right]"
	great_node.text = "[right][color=violet]" + str(0) + "[/color][/right]"
	nice_node.text = "[right][color=cyan]" + str(0) + "[/color][/right]"

""" Called each frame """
func _process(_delta):
	pass

""" Set minigame values for movement interface """
func add_move(v: Minigame) -> int:
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

func _on_minigame_completed(minigame_type: MinigameTypes.type, res: float, score: int, rank: String):
	Global.score_iq += score
	match rank:
		"perfect":
			Global.perfect_counter += 1
		"great":
			Global.great_counter += 1
		"nice":
			Global.nice_counter += 1
	
	iq_node.text = "[right][color=white]" + str(Global.score_iq) + "[/color][/right]"
	perfect_node.text = "[right][color=gold]" + str(Global.perfect_counter) + "[/color][/right]"
	great_node.text = "[right][color=violet]" + str(Global.great_counter) + "[/color][/right]"
	nice_node.text = "[right][color=cyan]" + str(Global.nice_counter) + "[/color][/right]"
