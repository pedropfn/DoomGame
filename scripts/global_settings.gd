extends Node

@onready var settings = ConfigFile.new()

@onready var FULLSCREEN
@onready var VSYNC
@onready var RENDER_QUALITY = 0.75
@onready var MAIN_VOLUME
@onready var SFX_VOLUME
@onready var BGM_VOLUME
@onready var MOUSE_SENS = 0.5

func _ready():
	settings.load("user://settings.cfg")
	if !settings:
		MOUSE_SENS = 0.5
		RENDER_QUALITY = 0.75
		
	for setting in settings.get_sections():
		FULLSCREEN = settings.get_value(setting, "fullscreen_toggled")
		VSYNC = settings.get_value(setting, "vsync_toggled")
		RENDER_QUALITY = settings.get_value(setting, "scale_quality_item_selected")
		MAIN_VOLUME = settings.get_value(setting, "main_volume_value_changed")
		SFX_VOLUME = settings.get_value(setting, "sfx_volume_value_changed")
		BGM_VOLUME = settings.get_value(setting, "bgm_volume_value_changed")
		MOUSE_SENS = settings.get_value(setting, "mouse_sense_value_changed")

func fullscreen_toggled(toggled_on: bool) -> void:
	FULLSCREEN = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	save_settings()

func vsync_toggled(toggled_on: bool) -> void:
	VSYNC = toggled_on
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	save_settings()

func scale_quality_item_selected(index: int) -> void:
	var option = [1, 0.75, 0.5, 0.25]
	RENDER_QUALITY = option[index]
	get_tree().root.scaling_3d_scale = RENDER_QUALITY
	save_settings()

func main_volume_value_changed(value: float) -> void:
	MAIN_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
	save_settings()

func sfx_volume_value_changed(value: float) -> void:
	SFX_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("sfx"), value)
	save_settings()

func bgm_volume_value_changed(value: float) -> void:
	BGM_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("bgm"), value)
	save_settings()

func mouse_sense_value_changed(value: float) -> void:
	MOUSE_SENS = value
	save_settings()
	
func save_settings():
	settings.set_value("settings", "fullscreen_toggled", FULLSCREEN)
	settings.set_value("settings", "vsync_toggled", VSYNC)
	settings.set_value("settings", "scale_quality_item_selected", RENDER_QUALITY)
	settings.set_value("settings", "main_volume_value_changed", MAIN_VOLUME)
	settings.set_value("settings", "sfx_volume_value_changed", SFX_VOLUME)
	settings.set_value("settings", "bgm_volume_value_changed", BGM_VOLUME)
	settings.set_value("settings", "mouse_sense_value_changed", MOUSE_SENS)
	
	settings.save("user://settings.cfg")
