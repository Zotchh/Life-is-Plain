extends Control

signal dead()

@export var gui_node: MarginContainer
@export var modifier_name: String

@onready var timer: Timer = $ResourceTimer
@onready var pb: TextureProgressBar = $ResourceProgressBar
var modifier: RichTextLabel

const PB_MAX: float = Global.RESOURCE_MAX
const PB_MIN: float = Global.RESOURCE_MIN
const PB_START: float = Global.RESOURCE_START
const PB_STEP: float = Global.RESOURCE_UPDATE_STEP

var type_from_name: Dictionary = {
	"EnergyBar": ResourceTypes.type.ENERGY,
	"MentalBar": ResourceTypes.type.MENTAL,
	"HappinessBar": ResourceTypes.type.HAPPINESS,
	"HungerBar": ResourceTypes.type.HUNGER,
}

func _ready():
	if type_from_name[self.name] != ResourceTypes.type.HUNGER:
		modifier = $ResourceModifier/Modifier
	
	pb.max_value = PB_MAX
	pb.min_value = PB_MIN
	pb.value = PB_START
	
	timer.timeout.connect(_on_timeout)
	gui_node.timer_start.connect(_on_timer_started)
	gui_node.timer_stop.connect(_on_timer_stopped)
	gui_node.resource_increment.connect(_on_resource_incremented)

func _process(_delta):
	update_modifier()
	check_death()

func check_death():
	if pb.value <= 0 && type_from_name[self.name] == ResourceTypes.type.HUNGER:
		dead.emit()

func update_modifier():
	var modifier_value = pb.value / PB_MAX
	modifier_value += 1.0
	
	if modifier != null:
		modifier.text = "x" + ("%.1f" % modifier_value)
		match modifier_name:
			"EnergyBar":
				Global.energy_modifier = modifier_value
			"MentalBar":
				Global.mental_modifier = modifier_value
			"HappinessBar":
				Global.happiness_modifier = modifier_value

func _on_timeout():
	if type_from_name[self.name] != ResourceTypes.type.HAPPINESS:
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
