extends CharacterBody3D

@onready var animatedSprite3d = $AnimatedSprite3D

@export var moveSpeed = 2.0
@export var attackRange = 2.0

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

var life = 100
var dead = false

func _physics_process(_delta):
	if dead:
		return
	if player == null:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * moveSpeed
	move_and_slide()
	hitPlayer()

func hitPlayer():
	var distToPlayer = global_position.distance_to(player.global_position)
	
	if distToPlayer > attackRange:
		return
	
	var eyeLine = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eyeLine, player.global_position+eyeLine, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		player.takeDamge()

func takeDamge():
	if life == 0:
		return
	life -= 10
	%DamageSound.play()
	if life == 0:
		%DamageSound.stop()
		killBoss()

func killBoss():
	dead = true
	player.increaseScore()
	$DeathSound.play()
	animatedSprite3d.play("death")
	$CollisionShape3D.disabled = true
