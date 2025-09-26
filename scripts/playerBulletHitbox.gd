extends Area2D

@onready var bossHurt = preload("res://assets/audio/sfx/bossHurt.wav")

func _on_body_entered(body):
	Globals.playSound(bossHurt)
	get_tree().call_group("boss", "takeDamage")
	get_parent().queue_free()
	
	# add 10 to score
	Globals.score += 10
