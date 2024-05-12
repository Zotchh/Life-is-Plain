extends MarginContainer

# Signals
signal timer_start()
signal timer_stop()
signal resource_increment(resource_type: ResourceTypes.type, value: int)

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

func _on_minigame_completed(minigame_type: MinigameTypes.type, res: float, score: int, rank: String):
	match minigame_type:
		MinigameTypes.type.PROGRAMMING:
			resource_increment.emit(ResourceTypes.type.ENERGY, res)
		MinigameTypes.type.CHEMISTRY:
			resource_increment.emit(ResourceTypes.type.MENTAL, res)

