extends Node2D

@onready var mouseSense = GlobalSettings.MOUSE_SENS
@onready var renderQuality = GlobalSettings.RENDER_QUALITY

func _ready() -> void:
	%fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	%vsync.button_pressed = true if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED else false
	# %ScaleQuality.value = renderQuality

	%MainVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	%SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	%BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("bgm")))
	
	%MouseSenseLabel.text = "MouseSense: " + str(mouseSense)
	%MouseSense.value = mouseSense
	

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_settings_pressed() -> void:
	%MainButtons.visible = false
	%SettingsMenu.visible = true

func _on_credits_pressed() -> void:
	%MainButtons.visible = false
	%CreditsMenu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	%MainButtons.visible = true
	%SettingsMenu.visible = false
	%CreditsMenu.visible = false

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	GlobalSettings.fullscreen_toggled(toggled_on)

func _on_vsync_toggled(toggled_on: bool) -> void:
	GlobalSettings.vsync_toggled(toggled_on)

func _on_scale_quality_item_selected(index: int) -> void:
	GlobalSettings.scale_quality_item_selected(index)

func _on_main_volume_value_changed(value: float) -> void:
	GlobalSettings.main_volume_value_changed(value)

func _on_sfx_volume_value_changed(value: float) -> void:
	GlobalSettings.sfx_volume_value_changed(value)

func _on_bgm_volume_value_changed(value: float) -> void:
	GlobalSettings.bgm_volume_value_changed(value)

func _on_mouse_sense_value_changed(value: float) -> void:
	mouseSense = value
	%MouseSenseLabel.text = "MouseSense: " + str(mouseSense)
