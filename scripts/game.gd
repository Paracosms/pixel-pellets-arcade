extends SubViewport

@onready var gameStartSound = preload("res://assets/audio/sfx/gameStart.wav")

# global variable location
@export var score: int = 0
@export var hurtLogicComponent: Node;

var playerAlive = true
var transitionCompleted = true
var lastEnemyPos = Vector2.ZERO
var lastAttackPhase = 1

func setSize(newSize : Vector2):
	get_parent().size = Vector2(newSize)
	var centerDisplacement = Vector2((Globals.baseResolution.x - newSize.x)*0.5,(Globals.baseResolution.y - newSize.y)*0.5)
	
	get_parent().position = centerDisplacement

func displayDeathScreen():
	%death.visible = true

# reduces lives and resolution, and resets player position
func hurt():
	hurtLogicComponent.hurt()

# resets window to normal size, overlays death ui and disables the player
func kill():
	playerAlive = false
	hurtLogicComponent.kill()

# reset lives, resolution, player position, and kill all bullets
func reset():
	playerAlive = true
	hurtLogicComponent.reset()

func _ready():
	get_node("sfxPlayer").play()
	%player.connect("damagePlayer", hurt)
	hurtLogicComponent.connect("displayDeathScreen", displayDeathScreen)
	reset()

func _process(delta: float) -> void:
	Globals.baseResolution = DisplayServer.window_get_size()
	if playerAlive:
		Globals.playerPos = %player.position
