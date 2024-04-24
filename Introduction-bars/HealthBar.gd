extends ProgressBar

# Health variable
var health = 100  # Starting health.

onready var health_bar = $HealthBar

func _ready():
	# Initialize the health bar's value.
	update_health_bar()

func take_damage(amount):
	health -= amount
	health = max(health, 0)  # Prevent health from dropping below 0.
	update_health_bar()

func heal(amount):
	health += amount
	health = min(health, 100)  # Prevent health from exceeding the max.
	update_health_bar()

func update_health_bar():
	health_bar.value = health 
