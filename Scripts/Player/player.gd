extends CharacterBody2D

@export var move_speed: float = 100
@export var diagonale_ratio: float = 1.4
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2

func _physics_process(delta: float):
	# Get the input direction
	var input_direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = input_direction * move_speed
	
	# Update velocity
	if ((input_direction.x > 0 or input_direction.x < 0)
	and (input_direction.y > 0 or input_direction.y < 0)):
		velocity = velocity / diagonale_ratio
	
	# Determine the animation to play
	play_animation(input_direction)
	
	# Call movement method
	move_and_slide()


func play_animation(input_direction: Vector2):
	if velocity.y > 0:
		anim.play("run down")
		last_direction = input_direction
	elif velocity.y < 0:
		anim.play("run up")
		last_direction = input_direction
	else:
		if velocity.x > 0:
			anim.play("run right")
			last_direction = input_direction
		elif velocity.x < 0:
			anim.play("run left")
			last_direction = input_direction
		else:
			play_idle_animation()


func play_idle_animation():
	if last_direction.y > 0:
		anim.play("idle down")
	elif last_direction.y < 0:
		anim.play("idle up")
	else:
		if last_direction.x > 0:
			anim.play("idle right")
		elif last_direction.x < 0:
			anim.play("idle left")
