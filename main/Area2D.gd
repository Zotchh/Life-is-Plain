extends Area2D

var entered = false
var sequence = [] # This will hold the sequence of actions to be checked
var currentActionIndex = 0 # Index of the current action in the sequence
var next_scene = ""

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	print(get_tree().get_current_scene().get_name())
	if get_tree().get_current_scene().get_name() == "Node":
		# Set up the sequence of actions
		sequence = ["movement", "up", "down", "up", "down" ]
		next_scene = "res://main/level2.tscn"
	if get_tree().get_current_scene().get_name() == "Node2":
		# Set up the sequence of actions
		sequence = ["movement", "down", "up", "down", "up" ]
		next_scene = "res://main/level.tscn"


func _on_body_entered(body: CharacterBody2D):
	entered = true


func _on_body_exited(body: CharacterBody2D):
	entered = false
	
func _process(delta):
	if entered == true:
		#print(sequence[currentActionIndex])
		if Input.is_action_just_pressed(sequence[currentActionIndex]):
			# Move to the next action in the sequence
			currentActionIndex += 1
			
			# If all actions in the sequence are pressed in order
			if currentActionIndex == sequence.size():
				# Perform your desired action
				print("Sequence completed!")
				
				# Reset the sequence
				currentActionIndex = 0
				get_tree().change_scene_to_file(next_scene)
