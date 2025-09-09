extends Control

func _ready() -> void:
	get_parent().hurtLogicComponent.connect("updateHealthSprites", updateHealth)

func updateHealth():
	match Globals.lives:
		3: %life4.visible = false
		2: %life3.visible = false
		1: %life2.visible = false
		0: %life1.visible = false

func _process(delta: float) -> void:
	%bossHealthBar.max_value = Globals.maxBossHealth
	%bossHealthBar.value = Globals.bossHealth
