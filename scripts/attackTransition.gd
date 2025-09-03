extends CharacterBody2D
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var pathTracer : PathFollow2D = $attackPattern/pathTracer

@onready var attack1 = preload("res://scenes/attack1.tscn")
@onready var attack2 = preload("res://scenes/attack2.tscn")

# change texture
@onready var pinkTexture = preload("res://assets/sprites/bulletPink.png")

var transitioningTo : int

# attack transition:
# shoot directly at the player while transitioning to a center point

# TODO create a transitionTO function that starts the transition to that attack
func transitionTo(atkSceneNum : int):
	
	transitioningTo = atkSceneNum
	
	position = get_tree().get_root().get_node("game").lastEnemyPos
	
	transition()

# speed (in pixels per second) that follows that path
@export var speed = 100

func transition():
	# create curve
	
	var path = Curve2D.new()
	path.add_point(position)
	path.add_point(Vector2(960,300))
	$attackPattern.set_curve(path)


func spawn_bullets():
	
	# get player pos from parent
	var playerPos = get_parent().get_parent().get_player_position()
	
	#the vector towards the player is the inverted difference vector between the enemy & player
	var differenceVector = global_position - playerPos
	var angle = differenceVector.normalized() * -1
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
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
	spawn_bullets()

func _process(delta):
	rotation += PI/360
	position = pathTracer.position
	pathTracer.progress += speed * delta
	
	# if path transition is finished, update the game
	if pathTracer.progress_ratio == 1:
		get_tree().get_root().get_node("game").transitionCompleted = true
		
		if transitioningTo == 1:
			var attack1Scene = attack1.instantiate()
			get_parent().get_parent().add_child(attack1Scene)
		elif transitioningTo == 2:
			var attack2Scene = attack2.instantiate()
			get_parent().get_parent().add_child(attack2Scene)
		self.queue_free()

func _ready():
	get_tree().get_root().get_node("game").transitionCompleted = false
	
	#var x = randf_range(0, 1920)
	#var y = randf_range(0, 1080)
	#transition()
