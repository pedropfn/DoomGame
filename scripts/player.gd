extends CharacterBody3D

var speed = 5.0

@onready var animatedSprite2d = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var rayCast3d = $RayCast3D
@onready var shootSound = $ShootSound
@onready var footstepSound = %FootstepSound
@onready var lifeLabel = %LifeLabel
@onready var scoreLabel = %ScoreLabel

@onready var currentScene = get_tree().current_scene.name
@onready var mainMenu = get_tree().get_first_node_in_group("MainMenu")
@onready var mouseSense = GlobalSettings.MOUSE_SENS
@onready var renderQuality = GlobalSettings.RENDER_QUALITY

@onready var canShoot = true
@onready var dead = false
@onready var life = 100
@onready var score = 0
@onready var goal = 0

func _ready():
	nextGoal()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animatedSprite2d.animation_finished.connect(shootAnimationReady)
	
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)
	$CanvasLayer/EndScreen/Panel/Button.button_up.connect(restart)
	$CanvasLayer/WinScreen/Panel/Button.button_up.connect(nextStage)
	
	%fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	%vsync.button_pressed = true if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED else false
	# %ScaleQuality.value = renderQuality

	%MainVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	%SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	%BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("bgm")))
	
	%MouseSenseLabel.text = "MouseSense: " + str(mouseSense)
	%MouseSense.value = mouseSense

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouseSense

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		if $CanvasLayer/SettingsScreen.visible == false:
			$CanvasLayer/SettingsScreen.show()
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			$CanvasLayer/SettingsScreen.hide()
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	if Input.is_action_just_pressed("restart"):
		restart()
	
	if dead:
		return
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(_delta):
	if dead:
		return

	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if !footstepSound.playing:
			footstepSound.pitch_scale = randf_range(.8, 1.2)
			footstepSound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		footstepSound.stop()
	
	move_and_slide()

func restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func nextGoal():
	match currentScene:
		"World":
			goal = 15 # 20
		"world2":
			goal = 10 # harder enemys
		"world3":
			goal = 1 # boss

func nextStage():
	match currentScene:
		"World":
			get_tree().change_scene_to_file("res://scenes/world_2.tscn")
		"world2":
			get_tree().change_scene_to_file("res://scenes/world_3.tscn")

func shoot():
	if !canShoot:
		return
	canShoot = false
	animatedSprite2d.play("shoot")
	shootSound.play()
	if rayCast3d.is_colliding() and rayCast3d.get_collider().has_method("takeDamge"):
		rayCast3d.get_collider().takeDamge()

func shootAnimationReady():
	canShoot = true

func increaseScore():
	score += 1
	scoreLabel.text = "Pigs Killed: " + str(score)
	if score == goal:
		%BackgroundSound.stop()
		%WinnerSound.play()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if !currentScene == "world3":
			$CanvasLayer/WinScreen.show()
		else:
			$CanvasLayer/EndScreen.show()

func takeDamge():
	if life == 0:
		return

	life -= 1
	lifeLabel.text = "Life: " + str(life)
	%TakeDamageSound.play()
	if life == 0:
		kill()
	
func kill():
	dead = true
	%GameOverSound.play(0.2)
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_back_pressed() -> void:
	$CanvasLayer/SettingsScreen.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


### Settings

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_settings_pressed() -> void:
	restart()

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
