extends Node

enum difficulty_level {
	EASY = 0,
	MEDIUM = 1,
}

const SCORE_INCREMENT: float = 2
const SCORE_DECREMENT: float = 1

const EASY_MAX_INSTR: int = 3
const MEDIUM_MAX_INSTR: int = 3

var difficulty: int = difficulty_level.MEDIUM
var score: int = 0
