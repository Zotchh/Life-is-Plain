extends Node2D

signal programming_minigame_started()
signal programming_minigame_closed()

var minigame_types = preload("res://main/minigame_types.gd")

@onready var player_node = $Player
@onready var programming_minigame_node = $"../ProgrammingMiniGame"

func _ready():
	player_node.minigame_started.connect(_on_minigame_started)
	player_node.minigame_closed.connect(_on_minigame_closed)

func _process(_delta):
	pass

func _on_minigame_started(minigame_type):
	programming_minigame_node.set_visible(true)
	
	if minigame_type == minigame_types.PROGRAMMING:
		programming_minigame_started.emit()

func _on_minigame_closed(minigame_type):
	programming_minigame_node.set_visible(false)
	
	if minigame_type == minigame_types.PROGRAMMING:
		programming_minigame_closed.emit()
