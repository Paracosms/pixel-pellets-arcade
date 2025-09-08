extends Node

@onready var hurtSound = preload("res://assets/audio/sfx/playerHurt.wav")
@onready var deathSound = preload("res://assets/audio/sfx/playerDeath.wav")

signal updateHealthSprites
signal displayDeathScreen

func loseLife():
	Globals.lives -= 1
	emit_signal("updateHealthSprites")
	if Globals.lives == 0: 
		# get_parent() is necessary here so that the game variable playerAlive is reset
		get_parent().kill()

func setResolution(resolution : Vector2): 
	get_parent().setSize(resolution)

# reduces lives and resolution, and clears nearby bullets
# polish: add a cold front effect that shows what bullets are cleared
func hurt():
	loseLife()
	Globals.playSound(hurtSound)
	Globals.currentResolution *= Globals.scaleFactors[Globals.lives - 1]
	setResolution(Globals.currentResolution)
	get_tree().call_group("areaSurroundingPlayer", "clearArea")

# resets window to normal size, overlays death ui and disables the player
# polish: add a tv turn off when you die
func kill():
	Globals.playSound(deathSound)
	setResolution(Globals.baseResolution)
	Globals.currentResolution = Globals.baseResolution
	get_tree().call_group("player", "die")
	emit_signal("displayDeathScreen")
	get_tree().call_group("invisibleOnDeath", "turnInvisible")

# reset lives, resolution, player position, and kill all bullets
func reset():
	Globals.lives = 4
	get_tree().call_group("invisibleOnDeath", "turnVisible")
	setResolution(Globals.baseResolution)
	emit_signal("updateHealthSprites")
	
