extends Control

@onready var timer: Timer = $ResourceTimer
@onready var pb: TextureProgressBar = $ResourceProgressBar

const PB_STEP: int = 2

func _ready():
	timer.timeout.connect(_on_timeout)

func _process(_delta):
	print(timer.time_left)

func _on_timeout():
	pb.value -= PB_STEP
