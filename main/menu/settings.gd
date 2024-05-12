extends MarginContainer

""" Script for option menu
	- Handle global variable on modification
"""

signal option_closed()

@export var pause_node: MarginContainer
@export var menu_node: Control

@onready var close_button: Button = $BackgroundMarginContainer/ContentMargin/CloseButton
@onready var resolution_option: OptionButton = $BackgroundMarginContainer/ContentMargin/ContentContainer/VideoMargin/VideoContainer/ButtonContainer/ResolutionOption
@onready var difficulty_option: OptionButton = $BackgroundMarginContainer/ContentMargin/ContentContainer/GameMargin/GameContainer/ButtonContainer/DifficultyOption
@onready var fullscreen_button: CheckButton = $BackgroundMarginContainer/ContentMargin/ContentContainer/VideoMargin/VideoContainer/ButtonContainer/FullscreenCheck
@onready var master_slider: HSlider = $BackgroundMarginContainer/ContentMargin/ContentContainer/SoundMargin/SoundContainer/ButtonContainer/MasterSlider
@onready var music_slider: HSlider = $BackgroundMarginContainer/ContentMargin/ContentContainer/SoundMargin/SoundContainer/ButtonContainer/MusicSlider
@onready var sfx_slider: HSlider = $BackgroundMarginContainer/ContentMargin/ContentContainer/SoundMargin/SoundContainer/ButtonContainer/SFXSlider

var resolutions: Dictionary = {
	"3840x2160": Vector2i(3840, 2160),
	"3024x1964": Vector2i(3024, 1964),
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1366x768": Vector2i(1366, 768),
	"1536x864": Vector2i(1536, 864),
	"1280x720": Vector2i(1280, 720),
	"1440x900": Vector2i(1440, 900),
	"1600x900": Vector2i(1600, 900),
	"1024x600": Vector2i(1024, 600),
	"800x600": Vector2i(800, 600),
	"640x360": Vector2i(640, 360),
}

var difficulties: Dictionary = {
	"EASY": Global.difficulty_level.EASY,
	"MEDIUM": Global.difficulty_level.MEDIUM
}

func _ready():
	if pause_node != null:
		pause_node.option_opened.connect(_on_option_opened)
	if menu_node != null:
		menu_node.option_opened.connect(_on_option_opened)
	
	close_button.pressed.connect(_close_button_pressed)
	
	init_display_option()
	init_difficulty_option()
	init_sound_sliders()

func _process(_delta):
	pass

func get_res_index() -> int:
	var size: Vector2i = DisplayServer.window_get_size()
	return resolutions.values().find(size)

func is_fullscreen() -> bool:
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	return mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func init_display_option():
	resolution_option.item_selected.connect(_on_resolution_item_selected)
	fullscreen_button.toggled.connect(_on_fullscreen_toggled)

	for r in resolutions:
		resolution_option.add_item(r)
	resolution_option.select(get_res_index())
	fullscreen_button.set_pressed_no_signal(is_fullscreen())

func init_difficulty_option():
	difficulty_option.item_selected.connect(_on_difficulty_item_selected)
	
	for d in difficulties:
		difficulty_option.add_item(d)
	difficulty_option.select(Global.get_diff_index())

func init_sound_sliders():
	var master_index: int = AudioServer.get_bus_index(Global.MASTER_BUS)
	var music_index: int = AudioServer.get_bus_index(Global.MUSIC_BUS)
	var sfx_index: int = AudioServer.get_bus_index(Global.SFX_BUS)
	
	master_slider.value_changed.connect(_on_master_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))

func _on_option_opened():
	self.set_visible(true)

func _close_button_pressed():
	option_closed.emit()
	self.set_visible(false)

func _on_resolution_item_selected(index: int):
	var size: Vector2i = resolutions.get(resolution_option.get_item_text(index))
	DisplayServer.window_set_size(size)

func _on_difficulty_item_selected(index: int):
	var diff: Global.difficulty_level = difficulties.get(difficulty_option.get_item_text(index))
	Global.difficulty = diff

func _on_fullscreen_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_master_slider_changed(value: float):
	var bus_index: int = AudioServer.get_bus_index(Global.MASTER_BUS)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_music_slider_changed(value: float):
	var bus_index: int = AudioServer.get_bus_index(Global.MUSIC_BUS)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_sfx_slider_changed(value: float):
	var bus_index: int = AudioServer.get_bus_index(Global.SFX_BUS)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
