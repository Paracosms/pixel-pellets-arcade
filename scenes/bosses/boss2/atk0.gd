### This attack follows the player and shoots directly at them

extends Node

@export var SPEED : int = 100
@export var BULLETSPEED : int = 3
@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

func _ready() -> void:
	boss.currentPhaseIndex = 0

# run and look at the player
func getMovementPattern():
	boss.isMoving = true
	boss.isLookingAtPlayer = true

func getVelocity() -> Vector2:
	# direction is always final pos - initial pos
	return (Globals.playerPos - boss.global_position).normalized() * SPEED

# bulletTimer holds how long it should wait before it calls spawnBullets
func spawnBullets():
	var bullet = bulletScene.instantiate()
	
	bullet.position = boss.global_position
	bullet.velocity = boss.velocity * BULLETSPEED
	
	boss.get_parent().add_child(bullet)
	
