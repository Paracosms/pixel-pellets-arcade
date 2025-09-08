extends CharacterBody2D

var timesBounced = 0

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		timesBounced += 1
		if timesBounced == Globals.bulletBouncesBeforeDeath:
			queue_free()
		velocity = velocity.bounce(collision.get_normal())
	
