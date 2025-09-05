extends Area2D

func _on_body_entered(body):
	get_parent().queue_free()
	
	# add 10 to score
	get_tree().get_root().get_child(1).get_child(1).get_child(0).score += 10
