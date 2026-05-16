extends Node

@onready var FULLSCREEN = true
@onready var VSYNC = true
@onready var RENDER_QUALITY = 0.75
@onready var MAIN_VOLUME = 0.5
@onready var SFX_VOLUME = 0.5
@onready var BGM_VOLUME = 0.5
@onready var MOUSE_SENS = 0.5

func fullscreen_toggled(toggled_on: bool) -> void:
	FULLSCREEN = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func vsync_toggled(toggled_on: bool) -> void:
	VSYNC = toggled_on
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func scale_quality_item_selected(index: int) -> void:
	var option = [1, 0.75, 0.5, 0.25]
	RENDER_QUALITY = option[index]
	get_tree().root.scaling_3d_scale = RENDER_QUALITY

func main_volume_value_changed(value: float) -> void:
	MAIN_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)

func sfx_volume_value_changed(value: float) -> void:
	SFX_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("sfx"), value)

func bgm_volume_value_changed(value: float) -> void:
	BGM_VOLUME = value
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("bgm"), value)

func mouse_sense_value_changed(value: float) -> void:
	MOUSE_SENS = value
