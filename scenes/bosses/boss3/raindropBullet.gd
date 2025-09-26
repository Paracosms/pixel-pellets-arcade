extends Node2D

@export var timeBetweenBulletInitialization : float = 0.05
@export var flashesBeforeFalling : int = 2
@export var timeBetweenFlashes : float = 0.3
@export var BULLETSPEED : int = 400
@export var bulletDirection : Vector2

@onready var bulletScene = preload("res://scenes/bullet.tscn")

@onready var telegraphSpawnpoints : Array = %telegraphSpawnpoints.get_children()
var bullets : Array

func _ready() -> void:
	# initialize real bullets (disabled)
	for spawnpoint in telegraphSpawnpoints:
		var bullet = bulletScene.instantiate()
		bullet.position = spawnpoint.position
		bullet.name = "bullet"
		bullet.visible = false
		bullets.push_front(bullet)
		bullet.tree_exited.connect(func(): bullets.erase(bullet))
		add_child(bullet)
	
	# place each spawnpoint right after the other
	for spawnpoint in telegraphSpawnpoints:
		await get_tree().create_timer(timeBetweenBulletInitialization).timeout
		spawnpoint.visible = true
	
	# place real bullets behind placeholders
	for bullet in bullets:
		bullet.visible = true
	
	# flash a few times before falling
	for i in flashesBeforeFalling + 1:
		await get_tree().create_timer(timeBetweenFlashes).timeout
		
		for spawnpoint in telegraphSpawnpoints:
			spawnpoint.visible = true
		
		await get_tree().create_timer(timeBetweenFlashes).timeout
		
		for spawnpoint in telegraphSpawnpoints:
			spawnpoint.visible = false
	
	for spawnpoint in telegraphSpawnpoints:
		spawnpoint.visible = false
	
	# make the raindrop fall
	for bullet in bullets:
		bullet.velocity = bulletDirection * BULLETSPEED

func _physics_process(_delta: float) -> void:
	if bullets.is_empty():
		queue_free()
