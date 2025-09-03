extends CharacterBody2D
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var pathTracer : PathFollow2D = $attackPattern/pathTracer

# speed (in pixels per second) that follows that path
@export var speed = 200


func spawn_bullets():
	
	var angles = [0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2, 7*PI/4] # omg unit circle
	# how far from the enemy should the bullets spawn
	var offset = 5
	
	# for each angle in angles[], spawn an individualized bullet using that angle value
	for angle in angles:
		var bullet = bullet_scene.instantiate()
		get_parent().get_parent().add_child(bullet)
		
		# cos to get x vector, sin to get y vector
		var angleVector = Vector2(cos(angle), sin(angle))
		var angularOffset = angleVector * offset
		
		# sets individual bullet properties
		bullet.position = pathTracer.position # position of the spawner
		bullet.rotation = angle + rotation
		bullet.velocity = angleVector * 100
		bullet.name = "bullet"
		
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
	
