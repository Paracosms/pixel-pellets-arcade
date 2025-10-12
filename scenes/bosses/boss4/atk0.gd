### DEFAULT BOSS ATK TEMPLATE
# after copy/pasting, change all items marked with TODO

extends Node2D

@export var SPEED : int = 200
@export var BULLETSPEED : int = 150

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var boss = get_parent()
@onready var corners = %corners.get_children()
var stopPosition : Vector2
var bulletDirection : Vector2

func _ready() -> void:
	boss.currentPhaseIndex = 0
	stopPosition = Globals.playerPos

func getMovementPattern():
	boss.isLookingAtPlayer = false

func getVelocity() -> Vector2:
	if (stopPosition - boss.global_position).length() >= 3:
		return (stopPosition - boss.global_position).normalized() * SPEED
	return Vector2.ZERO

# bulletTimer holds how long it should wait before it calls spawnBullets
# TODO: determine bullet spawning logic
func spawnBullets():
	for corner in corners:
		var x = corner.position.x
		var y = corner.position.y
		if (x < 0):
			if (y < 0): bulletDirection = Vector2(-1, -1)
			else: bulletDirection = Vector2(-1, 1)
		elif (y < 0): bulletDirection = Vector2(1, -1)
		else: bulletDirection = Vector2(1, 1)
		
		# spawn main bullet
		var bullet = bulletScene.instantiate()
		bullet.position = corner.global_position
		bullet.velocity = bulletDirection * BULLETSPEED
		boss.get_parent().add_child(bullet)
		
		# spawn pad bullets (makes corners more filled in)
		var pads = corner.get_children()
		for pad in pads:
			var padBullet = bulletScene.instantiate()
			padBullet.position = pad.global_position
			padBullet.velocity = bulletDirection * BULLETSPEED
			boss.get_parent().add_child(padBullet)
		
	
