### This attack moves the boss to the center and shoots 3 waves of bullets from each of its corners

extends Node

@export var SPEED : int = 200
@export var BULLETSPEED : int = 150

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

var timeAlive : float = 0
var stopPosition : Vector2 = Vector2(1920/2.0, 1080/2.0)
var isStopped : bool = false
var finalRotation : float
var rotating : bool

func _ready() -> void:
	boss.currentPhaseIndex = 0

func getMovementPattern():
	boss.isLookingAtPlayer = false

func getVelocity() -> Vector2:
	if boss.global_position == stopPosition:
		return Vector2.ZERO
	else:
		boss.rotation += PI/180
		return (stopPosition - boss.global_position).normalized() * SPEED

func spawnBullet(angle):
	var bullet = bulletScene.instantiate()
	
	# cos to get x vector, sin to get y vector
	var angleVector = Vector2(cos(angle), sin(angle))
	
	# sets individual bullet properties
	bullet.timesBounced = 0
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
func loopAttack():
	while(true):
		for i in 3:
			%waveTimer.start()
			await %waveTimer.timeout # spawns wave
		
		await get_tree().create_timer(0.3).timeout # cooldown before it rotates again
		
		# rotation goes from -pi to pi
		if (boss.rotation + PI/3) > PI:
			finalRotation = boss.rotation + PI/3 - 2*PI
		else:
			finalRotation = boss.rotation + PI/3
		
		
		while abs(boss.rotation - finalRotation) > 0.01:
			await get_tree().physics_frame
			boss.rotation += PI/120

func updateBulletVelocities():
	var periodicFunction = -asin(cos(cos(timeAlive))) + 3.2 
	var velocityMultiplier = Vector2(periodicFunction, periodicFunction)
	
	Globals.currentBullets = Globals.currentBullets.filter(func(n): return is_instance_valid(n) and !(n is Node and n.is_queued_for_deletion()))
	
	for bulletNode in Globals.currentBullets:
		bulletNode.velocity = bulletNode.baseVelocity * velocityMultiplier

func _physics_process(delta: float) -> void:
	timeAlive += delta
	updateBulletVelocities()
	
	# 3 is picked here because apparently thats the closest it gets to being on top of stopPosition
	# start spawning bullets if stopped
	if !isStopped && (stopPosition - boss.global_position).length() <= 3:
		boss.global_position = stopPosition
		isStopped = true
		loopAttack()
