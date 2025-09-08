extends Node

# ASSUMES THAT LIVES = 3

@onready var gameNode = get_parent()


# reduces lives and resolution, and resets player position
func hurt():
	
	Globals.lives -= 1
	if Globals.lives == 2:
		$"../hud/life4".visible = false
	elif Globals.lives == 1:
		$"../hud/life3".visible = false
	elif Globals.lives == 0:
		$"../hud/life2".visible = false
		# hotfix to fix random bug where life1 appears too far left
		$"../hud/life1".position = Vector2(2050,95)
	else:
		kill()
		pass
	
	# reduce resolution size and scale down the game to fit in the new resolution
	if Globals.lives > -1:
		DisplayServer.window_set_size(Globals.resolutions[Globals.lives])
		center_window()
		get_window().content_scale_factor = Globals.scaleFactors[Globals.lives]
		$"../player".get_node("killSurroundingBullets").clearArea()

# resets window to normal size, overlays death ui and disables the player
func kill():
	gameNode.playerAlive = false
	DisplayServer.window_set_size(Globals.resolutions[3])
	center_window()
	get_window().content_scale_factor = Globals.scaleFactors[3]
	$"../death".visible = true
	%player.queue_free()
	$"../hud/topLeft/scoreUpdater".visible = false
	$"../hud/topLeft/resolutionUpdater".visible = false


# reset lives, resolution, player position, and kill all bullets
func reset():
	Globals.lives = 3
	gameNode.playerAlive = true
	$"../hud/life4".visible = true
	$"../hud/life3".visible = true
	$"../hud/life2".visible = true
	$"../hud/life1".visible = true
	$"../hud/topLeft/scoreUpdater".visible = true
	$"../hud/topLeft/resolutionUpdater".visible = true
	DisplayServer.window_set_size(Globals.resolutions[3])
	get_window().content_scale_factor = Globals.scaleFactors[3]
	%player.position = Vector2(960, 900)

func center_window():
	var monitorSize = DisplayServer.screen_get_size()
	var windowSize = DisplayServer.window_get_size()
	# calculate the new position to center the window
	var newPosition = (monitorSize - windowSize) / 2
	DisplayServer.window_set_position(newPosition)

### everything below this line is old transition logic that im taking out of game.gd

#@onready var attack1 = preload("res://scenes/attack1.tscn")
#@onready var attack2 = preload("res://scenes/attack2.tscn")
#@onready var attack3 = preload("res://scenes/attack3.tscn")


# every 5 seconds, there's a 1/5 chance to transition attacks
#func _on_transition_cooldown_timeout():
	#var RNG = randi_range(1,3)
	#print(RNG)
	#if RNG == 3 && transitionCompleted:
		#var aRNG = randi_range(1,3)
		#var attackScene
		#
		#if aRNG == 1 && lastAttackPhase != 1:
			#attackScene = attack1.instantiate()
			#add_child(attackScene)
			#if self.has_node("attack2"):
				#self.get_node("attack2").queue_free()
			#if self.has_node("attack3"):
				#self.get_node("attack3").queue_free()
			#lastAttackPhase = 1
		#elif aRNG == 2 && lastAttackPhase != 2:
			#attackScene = attack2.instantiate()
			#add_child(attackScene)
			#if self.has_node("attack1"):
				#self.get_node("attack1").queue_free()
			#if self.has_node("attack3"):
				#self.get_node("attack3").queue_free()
			#lastAttackPhase = 2
		#elif aRNG == 3 && lastAttackPhase != 3:
			#attackScene = attack3.instantiate()
			#add_child(attackScene)
			#if self.has_node("attack1"):
				#self.get_node("attack1").queue_free()
			#if self.has_node("attack2"):
				#self.get_node("attack2").queue_free()
			#lastAttackPhase = 3
		#
