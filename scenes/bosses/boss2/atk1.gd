### This attack moves the boss to the center and shoots lines of bullets across the axes and diagonals

extends Node

@export var SPEED : int = 200
@export var BULLETSPEED : int = 150
@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

var stopPosition : Vector2 = Vector2(1920/2,1080/2)
var isStopped : bool = false
var dontShoot : bool = true

func _ready() -> void:
	boss.currentPhaseIndex = 1

# run and look at the player
func getMovementPattern():
	boss.isMoving = true
	boss.isLookingAtPlayer = false

func getVelocity() -> Vector2:
	# direction is always final pos - initial pos
	if boss.global_position == stopPosition:
		return Vector2.ZERO
	else:
		return (stopPosition - boss.global_position).normalized() * SPEED

# bulletTimer holds how long it should wait before it calls spawnBullets
func spawnBullets():
	var angles = [0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2, 7*PI/4] # omg unit circle
	# how far from the enemy should the bullets spawn
	var offset = 5
	
	# for each angle in angles[], spawn an individualized bullet using that angle value
	for angle in angles:
		var bullet = bulletScene.instantiate()
		boss.get_parent().add_child(bullet)
		
		# cos to get x vector, sin to get y vector
		var angleVector = Vector2(cos(angle), sin(angle))
		var angularOffset = angleVector * offset
		
		# sets individual bullet properties
		bullet.timesBounced = Globals.bulletBouncesBeforeDeath - 2
		bullet.position = boss.global_position # position of the spawner
		bullet.rotation = angle
		bullet.velocity = angleVector * BULLETSPEED
		bullet.name = "bullet"

func _physics_process(delta: float) -> void:
	# 3 is picked here because apparently thats the closest it gets to being on top of stopPosition
	if (stopPosition - boss.global_position).length() <= 3:
		boss.rotation += PI/180.0
	
	# start spawning bullets if stopped
	if !isStopped && (stopPosition - boss.global_position).length() <= 3:
		isStopped = true
		%bulletTimer.start()
