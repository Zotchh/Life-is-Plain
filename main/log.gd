extends Node

class_name Log

""" A Log class for debug
"""

""" Print only for debug """
static func print(x: String):
	if OS.is_debug_build():
		print(x)

""" Print only for debug if a flag is on """
static func print_if(x: String, f: bool):
	if OS.is_debug_build() && f:
			print(x)
