extends Node

class_name MinigameTypes

""" Represent a minigame type
"""

enum {
	PROGRAMMING=0,
	CHEMISTRY=1,
	ARCHITECTURE=2,
	MATH=3,
}

static func get_dest_name(type: int) -> String:
	match type:
		PROGRAMMING:
			return "PROG"
		CHEMISTRY:
			return "LAB"
		ARCHITECTURE:
			return "ARCH"
		MATH:
			return "MATH"
	
	return "UNMATCHED"
