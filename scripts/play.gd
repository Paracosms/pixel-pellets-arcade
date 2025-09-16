extends Button

@onready var hoverSound = preload("res://assets/audio/sfx/buttonHover.wav")

func _on_pressed():
	Globals.baseResolution = DisplayServer.window_get_size()
	get_tree().change_scene_to_file("res://scenes/window.tscn")

func _on_mouse_entered() -> void:
	Globals.playSound(hoverSound)
