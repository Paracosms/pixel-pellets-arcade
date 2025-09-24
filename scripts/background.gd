extends Sprite2D

func updateHue(newHue : float):
	material.set_shader_parameter("hueShift", newHue)

func _ready() -> void:
	Globals.backgroundHueUpdated.connect(updateHue)
