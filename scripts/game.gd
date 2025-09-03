extends Control

@onready var transitionScene = preload("res://scenes/attackTransition.tscn")

@onready var attack1 = preload("res://scenes/attack1.tscn")
@onready var attack2 = preload("res://scenes/attack2.tscn")
@onready var attack3 = preload("res://scenes/attack3.tscn")

# global variable location

@export var score: int = 0
@export var lives = 3 # (actually lives - 1), but it mainly serves as the index for resolutions and scaleFactors

var resolutions = [Vector2i(640, 360), Vector2i(854, 480),  Vector2i(1280,720) , Vector2i(1920,1080)]
var scaleFactors = [1280.0/3843, 4.0/9, 2.0/3, 1]
var playerAlive = true
var transitionCompleted = true
var lastPlayerPos = Vector2.ZERO
var lastEnemyPos = Vector2.ZERO
var lastAttackPhase = 1
var screenWidth
var screenHeight

# thought this was necessary, turns out it's not
# might be useful later
func updateSizeVariables():
	var raw = str(get_viewport().size)
	# remove parentheses
	raw = raw.replace("(", "")
	raw = raw.replace(")", "")
	# split into parts
	var parts = raw.split(", ")
	screenWidth = int(parts[0])
	screenHeight = int(parts[1])

func get_player_position() -> Vector2:
	if playerAlive:
		lastPlayerPos = get_node("player").position
		return lastPlayerPos
	else:
		return lastPlayerPos

# reduces lives and resolution, and resets player position
func hurt():
	
	lives -= 1
	if lives == 2:
		$hud/life4.visible = false
	elif lives == 1:
		$hud/life3.visible = false
	elif lives == 0:
		$hud/life2.visible = false
		# hotfix to fix random bug where life1 appears too far left
		$hud/life1.position = Vector2(2050,95)
	else:
		kill()
		pass
	
	# reduce resolution size and scale down the game to fit in the new resolution
	if lives > -1:
		DisplayServer.window_set_size(resolutions[lives])
		center_window()
		get_window().content_scale_factor = scaleFactors[lives]
		$player.get_node("killSurroundingBullets").clearArea()

# resets window to normal size, overlays death ui and disables the player
func kill():
	playerAlive = false
	DisplayServer.window_set_size(resolutions[3])
	center_window()
	get_window().content_scale_factor = scaleFactors[3]
	get_node("death").visible = true
	get_node("player").queue_free()
	$hud/topLeft/scoreUpdater.visible = false
	$hud/topLeft/resolutionUpdater.visible = false

func center_window():
	var monitorSize = DisplayServer.screen_get_size()
	var windowSize = DisplayServer.window_get_size()
	# calculate the new position to center the window
	var newPosition = (monitorSize - windowSize) / 2
	DisplayServer.window_set_position(newPosition)

# reset lives, resolution, player position, and kill all bullets
func reset():
	lives = 3
	playerAlive = true
	$hud/life4.visible = true
	$hud/life3.visible = true
	$hud/life2.visible = true
	$hud/life1.visible = true
	$hud/topLeft/scoreUpdater.visible = true
	$hud/topLeft/resolutionUpdater.visible = true
	DisplayServer.window_set_size(resolutions[3])
	get_window().content_scale_factor = scaleFactors[3]
	%player.position = Vector2(960, 900)

func _ready():
	reset()

# every 5 seconds, there's a 1/5 chance to transition attacks
func _on_transition_cooldown_timeout():
	var RNG = randi_range(1,3)
	print(RNG)
	if RNG == 3 && transitionCompleted:
		print("WHAT ARE YOU DOING")
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
		
