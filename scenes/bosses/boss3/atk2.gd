### This attack moves to a random position on the map while shooting triangle attacks at the player

extends Node

@export var SPEED : int = 300
@export var BULLETSPEED : int = 150

@onready var raindropAttackScene = preload("res://scenes/bosses/boss3/raindropBullet.tscn")
@onready var boss = get_parent()
@onready var stopPosition : Vector2 = getRandomScreenPosition()


func _ready() -> void:
	boss.currentPhaseIndex = 2
	boss.rotation = 0

func getMovementPattern():
	boss.isLookingAtPlayer = true

func getVelocity() -> Vector2:
	return (stopPosition - boss.global_position).normalized() * SPEED

# spawn 3 waves of bullets, rotate, spawn 3 waves of bullets
func attack():
	var raindrop = raindropAttackScene.instantiate()
	raindrop.position = boss.position + Vector2(0, 50) # 50 pixels below the boss for offset
	raindrop.rotation = boss.rotation - PI/2
	raindrop.bulletDirection = (Globals.playerPos - boss.global_position).normalized()
	raindrop.flashesBeforeFalling = 1
	raindrop.timeBetweenFlashes = 0.2
	boss.get_parent().add_child(raindrop)

func getRandomScreenPosition() -> Vector2:
	return Vector2(randi_range(0, 1920), randi_range(0, 1080))

func _physics_process(_delta: float) -> void:
	# start spawning bullets once end position reached
	if (stopPosition - boss.global_position).length() <= 4:
		stopPosition = getRandomScreenPosition()
