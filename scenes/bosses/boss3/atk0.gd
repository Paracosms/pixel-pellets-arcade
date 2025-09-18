### DEFAULT BOSS ATK TEMPLATE
# after copy/pasting, change all items marked with TODO

extends Node

@export var SPEED : int = 100
@export var BULLETSPEED : int = 150

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

var timeAlive : float = 0
var stopPosition : Vector2 = Vector2(1920/2, 1080/2)
var isStopped : bool = false

# TODO: update this template !
func _ready() -> void:
	boss.currentPhaseIndex = 0

# TODO: determine movement booleans
func getMovementPattern():
	#boss.isMoving = true
	#boss.isLookingAtPlayer = true
	pass

func getVelocity() -> Vector2:
	if boss.global_position == stopPosition:
		return Vector2.ZERO
	else:
		return (stopPosition - boss.global_position).normalized() * SPEED

# bulletTimer holds how long it should wait before it calls spawnBullets
# TODO: determine bullet spawning logic
func spawnBullets():
	var angles = [0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2, 7*PI/4] # omg unit circle
	
	# for each angle in angles[], spawn an individualized bullet using that angle value
	for angle in angles:
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

func updateBulletVelocities():
	var periodicFunction = -asin(cos(cos(timeAlive))) + 2.2
	var velocityMultiplier = Vector2(periodicFunction, periodicFunction)
	
	Globals.currentBullets = Globals.currentBullets.filter(func(n): return is_instance_valid(n) and !(n is Node and n.is_queued_for_deletion()))
	
	for bulletNode in Globals.currentBullets:
		bulletNode.velocity = bulletNode.baseVelocity * velocityMultiplier

func _physics_process(delta: float) -> void:
	timeAlive += delta
	updateBulletVelocities()
	
	# 3 is picked here because apparently thats the closest it gets to being on top of stopPosition
	if (stopPosition - boss.global_position).length() <= 3:
		boss.rotation += PI/180.0
	
	# start spawning bullets if stopped
	if !isStopped && (stopPosition - boss.global_position).length() <= 3:
		boss.global_position = stopPosition
		isStopped = true
		%bulletTimer.start()
