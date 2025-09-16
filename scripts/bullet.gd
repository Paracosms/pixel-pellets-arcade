extends CharacterBody2D

@export var timesBounced = 0

@onready var parriedBulletShader = preload("res://assets/other/chroma.tres")
@onready var parrySound = preload("res://assets/audio/sfx/parry.wav")

func _ready() -> void:
	get_node("parriedHurtBox/canHurtBossArea").disabled = true

func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta) 
	if collision:
		var collider = collision.get_collider()
		
		# checks if the collision occured on the parried wall (layer 6)
		if collider is StaticBody2D && (collider.collision_layer & (1 << 5)) != 0 && %recentlyParried.is_stopped():
			%recentlyParried.start()
			swapToParriedBullet()
		
		if %recentlyParried.is_stopped():
			timesBounced += 1
		
		if timesBounced == Globals.bulletBouncesBeforeDeath:
			queue_free()
		
		velocity = velocity.bounce(collision.get_normal())

func swapToParriedBullet():
	Globals.playSound(parrySound, -5)
	# parried bullets die after bouncing off the wall
	timesBounced = Globals.bulletBouncesBeforeDeath - 1
	# enable the bullet to deal damage to the boss, disable the ability to do damage to player
	get_node("parriedHurtBox/canHurtBossArea").disabled = false
	
	
	# change bullet attributes
	add_to_group("parriedBullet")
	velocity *= 1.5
	scale = Vector2(2,2)
	get_node("bulletSprite").material = parriedBulletShader
