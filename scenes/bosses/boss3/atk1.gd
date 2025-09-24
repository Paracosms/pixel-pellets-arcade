### This attack moves the boss near the top of the screen and moves left and right raining down triangle "raindrops"

extends Node

@export var SPEED : int = 100
@export var BULLETSPEED : int = 150

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()
@onready var stopPosition : Vector2 = Vector2(boss.global_position.x, 50)

var timeAlive : float = 0
var isStopped : bool = false
var rotating : bool = true
var direction : int
var finalRotation : float = PI/2 


func _ready() -> void:
	boss.currentPhaseIndex = 1
	boss.rotation = 0
	# if Globals.playerPos.x - boss.global_position.x is negative, the boss is to the right of the player, therefore it should move left towards it
	if (Globals.playerPos.x - boss.global_position.x) < 0:
		direction = -1 # move to the left
	else:
		direction = 1 # move to the left
		
func getMovementPattern():
	boss.isLookingAtPlayer = false

func getVelocity() -> Vector2:
	# direction is always final pos - initial pos
	if direction == -1 :
		# player is on the left; move left
		return Vector2(-1,0) * SPEED
	else:
		# player is on the right; move right
		return Vector2(1,0) * SPEED

func spawnBullet(angle):
	var bullet = bulletScene.instantiate()
	
	# cos to get x vector, sin to get y vector
	var angleVector = Vector2(cos(angle), sin(angle))
	
	# sets individual bullet properties
	bullet.timesBounced = Globals.bulletBouncesBeforeDeath - 2
	bullet.position = boss.global_position # position of the spawner
	bullet.rotation = angle
	bullet.velocity = angleVector * BULLETSPEED
	bullet.baseVelocity = bullet.velocity
	bullet.name = "bullet"
	
	boss.get_parent().add_child(bullet)
	Globals.currentBullets.push_front(bullet)



func spawnWave():
	# shoot at 30, 150, 270 degrees, but accounted for radians and imperfect integer equilateral triangle angles
	var angles = [0.525851, 2.619592, 4.700081]
	# for each angle in angles[], spawn an individualized bullet using that angle value
	for angle in angles:
			spawnBullet(angle + boss.rotation)

# spawn 3 waves of bullets, rotate, spawn 3 waves of bullets
func attack():
	for i in 3:
		%waveTimer.start()
		await %waveTimer.timeout # spawns wave
	
	await get_tree().create_timer(0.5).timeout # cooldown before it rotates again
	%rotateTransitionTimer.start()
	finalRotation = boss.rotation + PI/3

func updateBulletVelocities():
	var periodicFunction = -asin(cos(cos(timeAlive))) + 2.2
	var velocityMultiplier = Vector2(periodicFunction, periodicFunction)
	
	Globals.currentBullets = Globals.currentBullets.filter(func(n): return is_instance_valid(n) and !(n is Node and n.is_queued_for_deletion()))
	
	for bulletNode in Globals.currentBullets:
		bulletNode.velocity = bulletNode.baseVelocity * velocityMultiplier

func _physics_process(delta: float) -> void:
	
	timeAlive += delta
	updateBulletVelocities()
	
	# if the boss hits a wall, turn around
	if boss.position.x > 1920 || boss.position.x < 0:
		direction *= -1
	
	# start spawning bullets once end position reached
	if !isStopped && (stopPosition - boss.global_position).length() <= 3:
		boss.global_position = stopPosition
		isStopped = true
		
	if (stopPosition - boss.global_position).length() <= 3:
		attack()
		
	
	if (rotating && boss.rotation < finalRotation):
		boss.rotation -= PI/180
	else:
		rotating = false
