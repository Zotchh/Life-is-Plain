extends Control

signal countdown_ended()

@export var level_node: Node

@onready var pb: ProgressBar = $CountdownBar
@onready var timer: Timer = $CountdownBar/CountdownTimer

const COUNTDOWN_MAX: int = Global.COUNTDOWN_MAX
const COUNTDOWN_STEP: int = Global.COUNTDOWN_UPDATE_STEP

func _ready():
	pb.max_value = COUNTDOWN_MAX
	pb.min_value = 0
	pb.value = COUNTDOWN_MAX
	
	timer.timeout.connect(_on_timeout)
	level_node.start_countdown_timers.connect(_on_timer_started)

func _process(_delta):
	if pb.value == 0:
		countdown_ended.emit()

func _on_timeout():
	pb.value -= COUNTDOWN_STEP

func _on_timer_started():
	if timer.is_stopped():
		timer.start()
	
	Log.print("timer " + self.name + " unpaused")
	timer.paused = false

func _on_timer_stopped():
	Log.print("timer " + self.name + " paused")
	timer.paused = true
