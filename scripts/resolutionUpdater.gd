extends Label

var resolutions = ["640x360", "854x480", "1280x720", "1920x1080"]

func _process(delta):
	text = "Resolution: " + str(resolutions[Globals.lives - 1])

func turnInvisible():
	visible = false

func turnVisible():
	visible = true
