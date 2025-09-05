extends Node

signal updateHealthSprites
signal displayDeathScreen

func loseLife():
	Globals.lives -= 1
	emit_signal("updateHealthSprites")
	if Globals.lives == 0: 
		kill()

func setResolution(resolution : Vector2): 
	get_parent().setSize(resolution)

# reduces lives and resolution, and clears nearby bullets
# polish: add a cold front effect that shows what bullets are cleared
func hurt():
	loseLife()
	setResolution(Globals.resolutions[Globals.lives - 1])
	get_tree().call_group("areaSurroundingPlayer", "clearArea")

# resets window to normal size, overlays death ui and disables the player
# polish: add a tv turn off when you die
func kill():
	setResolution(Globals.baseResolution)
	get_tree().call_group("player", "die")
	emit_signal("displayDeathScreen")
	get_tree().call_group("invisibleOnDeath", "turnInvisible")

# reset lives, resolution, player position, and kill all bullets
func reset():
	Globals.lives = 4
	get_tree().call_group("invisibleOnDeath", "turnVisible")
	setResolution(Globals.baseResolution)
	emit_signal("updateHealthSprites")
	
