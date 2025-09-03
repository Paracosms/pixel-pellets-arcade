extends Label

func _process(delta):
	var root = get_tree().get_root().get_node("game")
	text = "Score: " + str(root.score)
