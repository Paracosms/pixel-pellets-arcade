extends Button

@onready var soundPlayer = get_node("soundPlayer")
@onready var hoverSound = preload("res://assets/audio/sfx/buttonHover.wav")

func _on_pressed():
	get_tree().quit()

func _on_mouse_entered() -> void:
	Globals.playSound(hoverSound)
