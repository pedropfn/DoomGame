extends Node2D

func _ready() -> void:
	%fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	%vsync.button_pressed = true if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED else false
	%MainVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	%SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	%BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("bgm")))

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
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_main_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("sfx"), value)


func _on_bgm_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("bgm"), value)


func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
