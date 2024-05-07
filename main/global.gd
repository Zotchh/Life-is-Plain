extends Node

enum difficulty_level {
	EASY = 0,
	MEDIUM = 1,
}

# movement
const MAX_MOVE: int = 4
var possible_moves: Array[String] = ["up", "down", "right", "left"]

# score
const RESOURCE_MAX: int = 1000
const RESOURCE_MIN_RANDOM: int = 550
const RESOURCE_MAX_RANDOM: int = 950
const RESOURCE_UPDATE_STEP: int = 1
const SCORE_INCREMENT: float = 2
const SCORE_DECREMENT: float = 1

# minigame
const EASY_MAX_INSTR: int = 3
const MEDIUM_MAX_INSTR: int = 3

# global
var difficulty: Global.difficulty_level = difficulty_level.MEDIUM
var score: int = 0
