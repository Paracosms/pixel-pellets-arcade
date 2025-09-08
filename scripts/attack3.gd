extends CharacterBody2D
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var pathTracer : PathFollow2D = $attackPattern/pathTracer

@onready var pinkTexture = preload("res://assets/sprites/bulletPink.png")

# speed (in pixels per second) that follows that path
@export var speed = 200


func spawn_bullets():
	
	#the vector towards the player is the inverted difference vector between the enemy & player
	var differenceVector = global_position - Globals.playerPos
	var angle = differenceVector.normalized() * -1
	
	var bullet = bullet_scene.instantiate()
	get_parent().get_parent().add_child(bullet)
	
	# sets individual bullet properties
	bullet.position = position # position of the spawner
	bullet.rotation = rotation
	bullet.velocity = angle * 300
	bullet.name = "bullet"
	bullet.get_node("bulletSprite").texture = pinkTexture
		
		# peak debugging code
		#print(bullet.position)
		#print("i need more bullets")

# every time the cooldown is up, spawn more bullets
func _on_cooldown_timeout():
	#rotation += PI / 8
	spawn_bullets()

func _process(delta):
	# report back position for transition purposes
	#get_tree().get_root().get_node("game").lastEnemyPos = position
	
	
	# constantly sets position to the pathfollow
	position = pathTracer.position
	pathTracer.progress += speed * delta
	
