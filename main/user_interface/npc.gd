extends Node2D

@onready var label = $LabelText
@onready var timer = $Timer

var text = "..."
var letter_index = 0

var citations = [
	["Balelec was cool, right guyz ?"],
	["I am not gonna survive this semester"],
	["I've been eating instant noodles for months"],
	["Hello there, general Kenobi"],
	["Hey, have you heard of Agepoly ?"],
	["All my homies hate Agepoly"],
	["Can you share me your notes please ?"],
	["I do cocaine everymorning to stay awake"],
	["I think that guy over there is doing cocaine"],
	["Jerome and Shayan are so cool !"],
	["I dreamt that we live in a video game, hahahaha"]
]

var punctuation_time = 0.2


func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		return
	
	timer.start(punctuation_time)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


