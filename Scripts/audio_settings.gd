extends Node

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var SFX_bus = AudioServer.get_bus_index("SFX")

@onready var master_v_slider: HSlider = $"../CanvasLayer/Settings/Sliders/MasterV_Slider"
@onready var music_v_slider: HSlider = $"../CanvasLayer/Settings/Sliders/MusicV_Slider"
@onready var sfxv_slider: HSlider = $"../CanvasLayer/Settings/Sliders/SFXV_Slider"


func _ready() -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(FileData.data["MasterVolume"]))
	master_v_slider.value = FileData.data["MasterVolume"]
	
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(FileData.data["MusicVolume"]))
	music_v_slider.value = FileData.data["MusicVolume"]
	
	AudioServer.set_bus_volume_db(SFX_bus, linear_to_db(FileData.data["SFXVolume"]))
	sfxv_slider.value = FileData.data["SFXVolume"]

func _on_master_v_slider_value_changed(value: float) -> void:
	
	if value <= 0:
		value = 0
	
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	FileData.data["MasterVolume"] = value

func _on_music_v_slider_value_changed(value: float) -> void:
	
	if value <= 0:
		value = 0
	
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	FileData.data["MusicVolume"] = value

func _on_sfxv_slider_value_changed(value: float) -> void:
	
	if value <= 0:
		value = 0
	
	AudioServer.set_bus_volume_db(SFX_bus, linear_to_db(value))
	FileData.data["SFXVolume"] = value
