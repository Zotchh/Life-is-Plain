extends Node

var key_root: String = "res://assets/sprites/key_icons/"
var food_root: String = "res://assets/sprites/GUI/Food/"

# Food for cafeteria minigame
var f_eggsalad = Food.new("minigame_p", food_root + "41_eggsalad_bowl.png", key_root + "key_p.tres")
var f_fruitcake = Food.new("minigame_f", food_root + "47_fruitcake_dish.png", key_root + "key_f.tres")

# Global array for public access
var foods: Array = [
	f_eggsalad, f_fruitcake
]
