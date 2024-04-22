extends MarginContainer

# Signals
signal timer_start()
signal timer_stop()
signal resource_increment(resource_type: int, value: int)

# External node
@export var level_node: Node2D
@export var minigame_node: MarginContainer

""" Called once when instanciated """
func _ready():
	level_node.start_resource_timers.connect(_on_timers_started)
	level_node.stop_resource_timers.connect(_on_timers_stopped)
	minigame_node.minigame_completed.connect(_on_minigame_completed)

""" Called each frame """
func _process(_delta):
	pass

func _on_timers_started():
	Log.print("timers started")
	timer_start.emit()

func _on_timers_stopped():
	Log.print("timers stopped")
	timer_stop.emit()

func _on_minigame_completed(minigame_type: int):
	match minigame_type:
		MinigameTypes.PROGRAMMING:
			resource_increment.emit(ResourceTypes.ENERGY, 300)
			resource_increment.emit(ResourceTypes.MENTAL, 200)
		MinigameTypes.CHEMISTRY:
			resource_increment.emit(ResourceTypes.HAPPINESS, 200)
			resource_increment.emit(ResourceTypes.HUNGER, 300)
