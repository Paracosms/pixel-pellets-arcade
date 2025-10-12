### DEFAULT BOSS ATK TEMPLATE
# after copy/pasting, change all items marked with TODO

extends Node

@export var SPEED : int = 100
@export var BULLETSPEED : int = 3

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()

# TODO: update this template !
func _ready() -> void:
	boss.currentPhaseIndex = 0

# TODO: determine movement booleans
func getMovementPattern():
	#boss.isLookingAtPlayer = true
	pass

# TODO: determine how the boss moves
func getVelocity() -> Vector2:
	#return (Globals.playerPos - boss.global_position).normalized() * SPEED
	return Vector2.ZERO

# bulletTimer holds how long it should wait before it calls spawnBullets
# TODO: determine bullet spawning logic
func spawnBullets():
	var bullet = bulletScene.instantiate()
	
	bullet.position = boss.global_position
	bullet.velocity = boss.velocity * BULLETSPEED
	
	boss.get_parent().add_child(bullet)
	
