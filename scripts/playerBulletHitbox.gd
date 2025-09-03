extends Area2D

func _on_body_entered(body):
	get_parent().queue_free()
	
	# add 10 to score
	get_tree().get_root().get_node("game").score += 10
