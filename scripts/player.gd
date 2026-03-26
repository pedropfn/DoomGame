extends CharacterBody3D

@onready var animatedSprite2d = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var rayCast3d = $RayCast3D
@onready var shootSound = $ShootSound
@onready var footstepSound = %FootstepSound

@onready var lifeLabel = %LifeLabel
@onready var scoreLabel = %ScoreLabel

@onready var currentScene = get_tree().current_scene.name

const SPEED = 5.0
const MOUSE_SENS = 0.3

var canShoot = true
var dead = false
var life = 100
var score = 0
var goal = 3

func _ready():
	nextGoal()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animatedSprite2d.animation_finished.connect(shootAnimationReady)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)
	$CanvasLayer/EndScreen/Panel/Button.button_up.connect(restart)
	$CanvasLayer/WinScreen/Panel/Button.button_up.connect(nextStage)

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if !footstepSound.playing:
			footstepSound.pitch_scale = randf_range(.8, 1.2)
			footstepSound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		footstepSound.stop()
	
	move_and_slide()


func restart():
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
