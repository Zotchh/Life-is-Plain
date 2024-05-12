extends Node

enum difficulty_level {
	EASY = 0,
	MEDIUM = 1,
}

# movement
const MAX_MOVE: int = 4
var possible_moves: Array[String] = ["up", "down", "right", "left"]

# score
const RESOURCE_MAX: float = 1000
const RESOURCE_MIN: float = -30
const RESOURCE_START: float = 733
const RESOURCE_UPDATE_STEP: float = 2
const SCORE_INCREASE_MIN: float = 38
const SCORE_STEEP: float = 50
const SCORE_HEIGHT: float = 1.5

var energy_modifier: float = 0
var mental_modifier: float = 0
var happiness_modifier: float = 0
var hunger_modifier: float = 0

var score_iq: int = 0
var perfect_counter: int = 0
var great_counter: int = 0
var nice_counter: int = 0

# minigame
const EASY_MAX_INSTR: int = 3
const MEDIUM_MAX_INSTR: int = 3

# sound
const MASTER_BUS: String = "Master"
const MUSIC_BUS: String = "Music"
const SFX_BUS: String = "SFX"

# global
const COUNTDOWN_MAX: int = 100
const COUNTDOWN_UPDATE_STEP: int = 2

var difficulty: Global.difficulty_level = difficulty_level.EASY

func get_diff_index() -> int:
	match difficulty:
		difficulty_level.EASY: return 0
		difficulty_level.MEDIUM: return 1
		
	return 0

func get_diff_modifier() -> float:
	match difficulty:
		difficulty_level.EASY: return 1.0
		difficulty_level.MEDIUM: return 0.85
	
	return 0
