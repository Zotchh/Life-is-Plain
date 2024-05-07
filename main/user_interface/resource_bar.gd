extends Control

@export var gui_node: MarginContainer

@onready var timer: Timer = $ResourceTimer
@onready var pb: TextureProgressBar = $ResourceProgressBar

const PB_MAX: int = Global.RESOURCE_MAX
const PB_MIN_RANDOM: int = Global.RESOURCE_MIN_RANDOM
const PB_MAX_RANDOM: int = Global.RESOURCE_MAX_RANDOM
const PB_STEP: int = Global.RESOURCE_UPDATE_STEP

var type_from_name: Dictionary = {
	"EnergyBar": ResourceTypes.type.ENERGY,
	"MentalBar": ResourceTypes.type.MENTAL,
	"HappinessBar": ResourceTypes.type.HAPPINESS,
	"HungerBar": ResourceTypes.type.HUNGER,
}

func _ready():
	pb.max_value = PB_MAX
	pb.min_value = 0
	pb.value = get_random_bar_value()
	
	timer.timeout.connect(_on_timeout)
	gui_node.timer_start.connect(_on_timer_started)
	gui_node.timer_stop.connect(_on_timer_stopped)
	gui_node.resource_increment.connect(_on_resource_incremented)

func _process(_delta):
	pass

func get_random_bar_value() -> int:
	return randi_range(PB_MIN_RANDOM, PB_MAX_RANDOM)

func _on_timeout():
	pb.value -= PB_STEP

func _on_timer_started():
	if timer.is_stopped():
		timer.start()
	
	Log.print("timer " + self.name + " unpaused")
	timer.paused = false

func _on_timer_stopped():
	Log.print("timer " + self.name + " paused")
	timer.paused = true

func _on_resource_incremented(resource_type: ResourceTypes.type, value: int):
	if type_from_name[self.name] == null:
		return
	
	if type_from_name[self.name] == resource_type:
		pb.value += value
