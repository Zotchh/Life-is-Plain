extends ProgressBar

@export var level_node: Node

@onready var timer: Timer = $CountdownTimer

const COUNTDOWN_MAX: int = Global.COUNTDOWN_MAX
const COUNTDOWN_STEP: int = Global.COUNTDOWN_UPDATE_STEP

func _ready():
	max_value = COUNTDOWN_MAX
	min_value = 0
	value = COUNTDOWN_MAX
	
	timer.timeout.connect(_on_timeout)
	level_node.start_countdown_timers.connect(_on_timer_started)
	level_node.stop_countdown_timers.connect(_on_timer_stopped)

func _process(_delta):
	if value == 0:
		get_tree().change_scene_to_file("res://main/menu/score.tscn")

func _on_timeout():
	value -= COUNTDOWN_STEP

func _on_timer_started():
	if timer.is_stopped():
		timer.start()
	
	Log.print("timer " + self.name + " unpaused")
	timer.paused = false

func _on_timer_stopped():
	Log.print("timer " + self.name + " paused")
	timer.paused = true
