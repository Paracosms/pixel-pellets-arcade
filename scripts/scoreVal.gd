extends Label

func _process(delta):
	var root = get_tree().get_root().get_child(1).get_child(1).get_child(0)
	text = str(root.score)
