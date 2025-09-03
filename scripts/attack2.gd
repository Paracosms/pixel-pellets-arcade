extends CharacterBody2D
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var pathTracer : PathFollow2D = $attackPattern/pathTracer

# change texture
@onready var purpleTexture = preload("res://assets/sprites/bulletPurple.png")


# attack 2:
# stand still, rotate while shooting lines

# speed (in pixels per second) that follows that path
@export var speed = 200


func spawn_bullets():
	
	#  unit circle divided into 5ths
	var angles = [0, 2*PI/5, 4*PI/5, 6*PI/5, 8*PI/5]
	
	# for each angle in angles[], spawn an individualized bullet using that angle value
	for angle in angles:
		var bullet = bullet_scene.instantiate()
		get_parent().get_parent().add_child(bullet)
		
		# cos to get x vector, sin to get y vector
		var angleVector = Vector2(cos(angle + rotation), sin(angle + rotation))
		
		# sets individual bullet properties
		bullet.position = position # position of the spawner
		bullet.rotation = angle + rotation
		bullet.velocity = angleVector * 100
		bullet.name = "bullet"
		bullet.get_node("bulletSprite").texture = purpleTexture
		
		# peak debugging code
		#print(bullet.position)
		#print("i need more bullets")

# every time the cooldown is up, spawn more bullets
func _on_cooldown_timeout():
	spawn_bullets()

func _ready():
	position = Vector2(960,300)

func _process(delta):	
	rotation += PI/720

