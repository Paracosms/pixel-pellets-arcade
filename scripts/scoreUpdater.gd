extends Label

func _process(_delta):
	text = "Score: " + str(Globals.score)

func turnInvisible():
	visible = false

func turnVisible():
	visible = true
