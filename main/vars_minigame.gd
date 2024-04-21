extends Node

var minigames_properties: Dictionary = {
	"LevelProgramming": Minigame.new(
		"level_programming", 
		MinigameTypes.PROGRAMMING,
		["▲", "◀", "▼", "▶"],
		["up", "left", "down", "right"],
		0,
	),

	"LevelChemistry": Minigame.new(
		"level_chemistry",
		MinigameTypes.CHEMISTRY,
		["▼", "▲", "▼", "▲"],
		["down", "up", "down", "up"],
		0,
	),
}
