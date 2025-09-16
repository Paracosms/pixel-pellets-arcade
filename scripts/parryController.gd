extends Node2D

func disableAll():
	%top.disable()
	%bottom.disable()
	%left.disable()
	%right.disable()
	%topLeft.disable()
	%topRight.disable()
	%bottomLeft.disable()
	%bottomRight.disable()

func _ready() -> void:
	disableAll()

func _physics_process(delta: float) -> void:
	var x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	var wallDirection = Vector2i(x, y)
	
	disableAll()

	if wallDirection != Vector2i.ZERO:
		match wallDirection:
			Vector2i(0, -1): %top.enable()
			Vector2i(0,  1): %bottom.enable()
			Vector2i(-1, 0): %left.enable()
			Vector2i(1,  0): %right.enable()
			Vector2i(-1,-1): %topLeft.enable()
			Vector2i(1, -1): %topRight.enable()
			Vector2i(-1, 1): %bottomLeft.enable()
			Vector2i(1,  1): %bottomRight.enable()
