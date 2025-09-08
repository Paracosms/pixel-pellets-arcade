### This attack moves to the boss up and down and shoots bullets directly left and right

extends Node

@export var SPEED : int = 200
@export var BULLETSPEED : int = 200
@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

var direction : int # negative = left, positive = right
var isStopped : bool = false

func _ready() -> void:
	boss.currentPhaseIndex = 2
	boss.rotation = PI/2
	# if Globals.playerPos.y - boss.global_position.y is negative, the boss is above the player, therefore it should move down towards it
	if (Globals.playerPos.y - boss.global_position.y) < 0:
		direction = -1 # moves down
	else:
		direction = 1 # moves up

# run and look at the player
func getMovementPattern():
	boss.isMoving = true
	boss.isLookingAtPlayer = false

func getVelocity() -> Vector2:
	# direction is always final pos - initial pos
	if direction == -1 :
		# player is above; move up
		return Vector2(0,-1) * SPEED
	else:
		# player is below, move down
		return Vector2(0,1) * SPEED

# bulletTimer holds how long it should wait before it calls spawnBullets
func spawnBullets():
	var angles = [0, PI] # horizontal
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
		bullet.position = boss.global_position # position of the spawner
		bullet.rotation = angle
		bullet.velocity = angleVector * BULLETSPEED
		bullet.name = "bullet"

func _physics_process(delta: float) -> void:
	# if the boss hits a wall, turn around
	if boss.position.y > 1080 || boss.position.y < 0:
		direction *= -1
