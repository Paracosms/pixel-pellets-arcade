extends StaticBody2D

@onready var left = get_node("left")
@onready var right = get_node("right")

func disable():
	left.disabled = true
	right.disabled = true
	visible = false

func enable():
	left.disabled = false
	right.disabled = false
	visible = true
