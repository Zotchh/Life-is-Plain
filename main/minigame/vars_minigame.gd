extends Node

var minigames_properties: Dictionary = {
	"LevelProgramming": Minigame.new(
		"level_programming", 
		MinigameTypes.PROGRAMMING,
		["▲", "◀", "▼", "▶"],
		["up", "left", "down", "right"],
		0,
		0x00dd00f0,
	),

	"LevelChemistry": Minigame.new(
		"level_chemistry",
		MinigameTypes.CHEMISTRY,
		["▼", "▲", "▼", "▲"],
		["down", "up", "down", "up"],
		0,
		0xb00510f0,
	),
	
	"LevelArchitecture": Minigame.new(
		"level_architecture",
		MinigameTypes.ARCHITECTURE,
		["▶", "▶", "◀", "▶"],
		["right", "right", "left", "right"],
		0,
		0xf6b500f0,
	),
	
	"LevelMath": Minigame.new(
		"level_math",
		MinigameTypes.MATH,
		["◀", "▲", "▼", "◀"],
		["left", "up", "down", "left"],
		0,
		0x2086d6f0,
	),
}
