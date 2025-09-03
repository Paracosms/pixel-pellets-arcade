extends Label

var resolutions = ["640x360", "854x480", "1280x720", "1920x1080"]

func _process(delta):
	var root = get_tree().get_root().get_node("game")
	text = "Resolution: " + str(resolutions[root.lives])

