extends Node

class_name MinigameTypes

""" Represent a minigame type
"""

enum type {
	PROGRAMMING=0,
	CHEMISTRY=1,
	ARCHITECTURE=2,
	MATH=3,
}

static func get_dest_name(type: MinigameTypes.type) -> String:
	match type:
		MinigameTypes.type.PROGRAMMING:
			return "PROG"
		MinigameTypes.type.CHEMISTRY:
			return "LAB"
	
	return "UNMATCHED"
