extends Node2D

signal minigame_started(type)
signal minigame_closed()

@onready var curr_scene = get_tree().current_scene.name

@onready var player_node = $Player
@onready var minigame_node = $"../MinigameInterface"

const MAX_MOVE = 4

var possible_moves = ["up", "down", "right", "left"]
var is_moving = false
var dest_candidates = []
var move_idx = 0

var minigames_from_scene: Dictionary = {
	"LevelProgramming": Minigame.new(
		"level_programming", 
		MinigameTypes.PROGRAMMING,
		["▲", "◀", "▼", "▶"],
		["up", "left", "down", "right"],
	),
	"LevelChemistry": Minigame.new(
		"level_chemistry",
		MinigameTypes.CHEMISTRY,
		["▼", "▲", "▼", "▲"],
		["down", "up", "down", "up"],
	),
}

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_released("interact"):
		var minigame: Minigame = minigames_from_scene[curr_scene]
		minigame_started.emit(minigame.type)
	
	if Input.is_action_just_released("close"):
		minigame_closed.emit()
	
	check_movement()

func check_movement():
	if Input.is_action_just_pressed("movement"):
		is_moving = !is_moving
		
	if is_moving:
		for move in possible_moves:
			if Input.is_action_just_pressed(move):
				print(move)
				print(move_idx)
				var has_matching = false
				var matching_key = null
				for key in minigames_from_scene:
					var value: Minigame = minigames_from_scene[key]
					if value.dest_keys[move_idx] == move:
						has_matching = true
						matching_key = key
				
				if has_matching:
					dest_candidates.append(matching_key)
					move_idx += 1
				else:
						move_idx = 0
						dest_candidates = []
	else:
		move_idx = 0
		dest_candidates = []
	
	if move_idx == MAX_MOVE:
		var dest_key = dest_candidates[0]
		var dest: Minigame = minigames_from_scene[dest_key]
		var dest_file = "res://main/" + dest.file_name + "/" + dest.file_name + ".tscn"
		get_tree().change_scene_to_file(dest_file)
