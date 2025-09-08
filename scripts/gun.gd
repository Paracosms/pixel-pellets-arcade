extends Timer

@onready var playerBulletScene = preload("res://scenes/playerBullet.tscn")
@onready var shootSound = preload("res://assets/audio/sfx/playerShoot.wav")

func spawn_bullets():
	Globals.playSound(shootSound, -25)
	
	var mousePos = get_parent().get_local_mouse_position()
	var direction = mousePos.normalized()
	const SPEED = 1000
	
	# spawn a bullet
	var playerBullet = playerBulletScene.instantiate()
	get_parent().get_parent().add_child(playerBullet)

	# sets individual playerBullet properties
	playerBullet.position = get_parent().position # position of the spawner
	playerBullet.rotation = direction.angle()
	playerBullet.velocity = direction * SPEED
	
	# peak debugging code
	#print(playerBullet.position)
	#print("i need more bullets")

# while shooting, spawn and fire bullets
func _on_timeout():
	if Input.is_action_pressed("shoot"):
		spawn_bullets()
