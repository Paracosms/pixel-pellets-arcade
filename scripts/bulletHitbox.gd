extends Area2D

func _on_body_entered(body):
		# runs the hurt function in the main game scene and kills itself
		get_tree().get_root().get_node("game").hurt()
		get_parent().queue_free()
