extends Node

class_name Log

""" A Log class for debug
"""

""" Print only for debug """
static func print(x: String):
	if OS.is_debug_build():
		print(x)
