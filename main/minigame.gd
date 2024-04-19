extends Node

class_name Minigame

var file_name: String
var type: int
var dest_names: Array
var dest_keys: Array

func _init(file_name: String, type: int, dest_names: Array, dest_keys: Array):
	self.file_name = file_name
	self.type = type
	self.dest_names = dest_names
	self.dest_keys = dest_keys
