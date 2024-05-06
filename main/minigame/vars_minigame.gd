extends Node

var res_root: String = "res://assets/sprites/icons/"

var minigames_properties: Dictionary = {
	"LevelProgramming": Minigame.new(
		"level_programming",
		"/root/VarsProgramming",
		MinigameTypes.PROGRAMMING,
		["▲", "◀", "▼", "▶"],
		["up", "left", "down", "right"],
		0,
		Color.hex(0x00dd00f0),
		res_root + "minigame_programming.tres",
		"PROGRAMMING"
	),

	"LevelChemistry": Minigame.new(
		"level_chemistry",
		"/root/VarsChemistry",
		MinigameTypes.CHEMISTRY,
		["▼", "▲", "▼", "▲"],
		["down", "up", "down", "up"],
		0,
		Color.hex(0xb00510f0),
		res_root + "minigame_chemistry.tres",
		"CHEMISTRY"
	),
	
	"LevelArchitecture": Minigame.new(
		"level_architecture",
		"/root/VarsArchitecture",
		MinigameTypes.ARCHITECTURE,
		["▶", "▶", "◀", "▶"],
		["right", "right", "left", "right"],
		0,
		Color.hex(0xf6b500f0),
		res_root + "minigame_architecture.tres",
		"ARCHITECTURE"
	),
	
	"LevelMath": Minigame.new(
		"level_math",
		"/root/VarsMath",
		MinigameTypes.MATH,
		["◀", "▲", "▼", "◀"],
		["left", "up", "down", "left"],
		0,
		Color.hex(0x2086d6f0),
		res_root + "minigame_math.tres",
		"MATH"
	),
}
