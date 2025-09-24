### This attack moves to the boss to the left and right and shoots bullets directly up and down

extends Node

@export var SPEED : int = 200
@export var BULLETSPEED : int = 200
@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

var direction : int # negative = left, positive = right
var isStopped : bool = false

func _ready() -> void:
	boss.currentPhaseIndex = 2
	boss.rotation = 0
	# if Globals.playerPos.x - boss.global_position.x is negative, the boss is to the right of the player, therefore it should move left towards it
	if (Globals.playerPos.x - boss.global_position.x) < 0:
		direction = -1 # move to the left
	else:
		direction = 1 # move to the left

# run and look at the player
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

# bulletTimer holds how long it should wait before it calls spawnBullets
func spawnBullets():
	var angles = [PI/2, 3*PI/2] # vertical
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
	if boss.position.x > 1920 || boss.position.x < 0:
		direction *= -1
