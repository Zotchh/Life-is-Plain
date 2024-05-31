extends Node

class_name Food

var key_value: String
var image: String
var key_icon: String

func _init(
	p_key_value: String,
	p_image: String,
	p_key_icon: String
):
	key_value = p_key_value
	image = p_image
	key_icon = p_key_icon
