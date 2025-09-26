### This attack moves the boss near the top of the screen and moves left and right raining down triangle "raindrops"

extends Node

@export var SPEED : int = 300
@export var BULLETSPEED : int = 150

@onready var bulletScene = preload("res://scenes/bullet.tscn")
@onready var raindropAttackScene = preload("res://scenes/bosses/boss3/raindropBullet.tscn")
@onready var boss = get_parent()
@onready var stopPosition : Vector2 = Vector2(boss.global_position.x, 50)

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
	if boss.global_position.y != stopPosition.y:
		return (stopPosition - boss.global_position).normalized() * SPEED * 2
	
	
	# direction is always final pos - initial pos
	if direction == -1 :
		# player is on the left; move left
		return Vector2(-1,0) * SPEED
	else:
		# player is on the right; move right
		return Vector2(1,0) * SPEED

# spawn 3 waves of bullets, rotate, spawn 3 waves of bullets
func attack():
	var raindrop = raindropAttackScene.instantiate()
	raindrop.position = boss.position + Vector2(0, 50) # 50 pixels below the boss for offset
	raindrop.bulletDirection = Vector2(0,1)
	boss.get_parent().add_child(raindrop)

func _physics_process(_delta: float) -> void:
	
	# if the boss hits a wall, turn around
	if boss.position.x > 1920 || boss.position.x < 0:
		direction *= -1
	
	# start spawning bullets once end position reached
	if !isStopped && (stopPosition - boss.global_position).length() <= 4:
		%attackTimer.start()
		boss.global_position = stopPosition
		isStopped = true
		
	#if (stopPosition - boss.global_position).length() <= 3:
	#	%attackTimer.start()
		
	
	if (rotating && boss.rotation < finalRotation):
		boss.rotation -= PI/180
	else:
		rotating = false
