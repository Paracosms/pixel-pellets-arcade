extends SubViewport

@onready var transitionScene = preload("res://scenes/attackTransition.tscn")

@onready var attack1 = preload("res://scenes/attack1.tscn")
@onready var attack2 = preload("res://scenes/attack2.tscn")
@onready var attack3 = preload("res://scenes/attack3.tscn")

# global variable location
@export var score: int = 0
@export var hurtLogicComponent: Node;

var playerAlive = true
var transitionCompleted = true
var lastPlayerPos = Vector2.ZERO
var lastEnemyPos = Vector2.ZERO
var lastAttackPhase = 1

func get_player_position() -> Vector2:
	if playerAlive:
		lastPlayerPos = %player.position
		return lastPlayerPos
	else:
		return lastPlayerPos

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
	%player.connect("damagePlayer", hurt)
	hurtLogicComponent.connect("displayDeathScreen", displayDeathScreen)
	reset()

# every 5 seconds, there's a 1/5 chance to transition attacks
func _on_transition_cooldown_timeout():
	var RNG = randi_range(1,3)
	print(RNG)
	if RNG == 3 && transitionCompleted:
		var aRNG = randi_range(1,3)
		var attackScene
		
		if aRNG == 1 && lastAttackPhase != 1:
			attackScene = attack1.instantiate()
			add_child(attackScene)
			if self.has_node("attack2"):
				self.get_node("attack2").queue_free()
			if self.has_node("attack3"):
				self.get_node("attack3").queue_free()
			lastAttackPhase = 1
		elif aRNG == 2 && lastAttackPhase != 2:
			attackScene = attack2.instantiate()
			add_child(attackScene)
			if self.has_node("attack1"):
				self.get_node("attack1").queue_free()
			if self.has_node("attack3"):
				self.get_node("attack3").queue_free()
			lastAttackPhase = 2
		elif aRNG == 3 && lastAttackPhase != 3:
			attackScene = attack3.instantiate()
			add_child(attackScene)
			if self.has_node("attack1"):
				self.get_node("attack1").queue_free()
			if self.has_node("attack2"):
				self.get_node("attack2").queue_free()
			lastAttackPhase = 3
		
