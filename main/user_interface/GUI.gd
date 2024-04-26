extends MarginContainer

# Signals
signal timer_start()
signal timer_stop()
signal resource_increment(resource_type: int, value: int)

# External node
@export var minigame_node: MarginContainer
@export var level_node: Node

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

func _on_minigame_completed(minigame_type: int, score: float):
	var incr = score * 300
	match minigame_type:
		MinigameTypes.PROGRAMMING:
			resource_increment.emit(ResourceTypes.ENERGY, incr)
		MinigameTypes.CHEMISTRY:
			resource_increment.emit(ResourceTypes.HUNGER, incr)
		MinigameTypes.ARCHITECTURE:
			resource_increment.emit(ResourceTypes.HAPPINESS, incr)
		MinigameTypes.MATH:
			resource_increment.emit(ResourceTypes.MENTAL, incr)

