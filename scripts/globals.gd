extends Node

var lives = 4 # serves as the index for resolutions and scaleFactors
var bossHealth : int = -1
var maxBossHealth : int = -1
var baseResolution = DisplayServer.window_get_size() # TODO: figure out difficulty scaling 
var bulletBouncesBeforeDeath = 3
var currentResolution : Vector2 = baseResolution
var scaleFactors = [320.0/427, 427.0/640, 2.0/3, 1]
var playerPos = Vector2.ZERO
var currentBullets = []
var parryVelocity = Vector2(300,300)
var currentBoss = 0

var score = 0 # remove later, outdated feature

@onready var bossScenes = [
	null,
	null,
	preload("res://scenes/bosses/boss2/boss2.tscn"),
	preload("res://scenes/bosses/boss3/boss3.tscn"),
	preload("res://scenes/bosses/boss4/boss4.tscn"),
]

signal backgroundHueUpdated(newHue : float)

func spawnNextBoss():
	currentBoss += 1
	var nextBoss = bossScenes[currentBoss].instantiate()
	nextBoss.position = Vector2(1920/2.0, 1080/2.0)
	get_node("/root/Window/gameViewer/game").add_child(nextBoss)

func changeBackgroundHue(newHue : float):
	emit_signal("backgroundHueUpdated", newHue)

func playSound(sound : AudioStream, volume : float = 0.0) -> void:
	var soundPlayer = AudioStreamPlayer.new()
	add_child(soundPlayer)
	soundPlayer.stream = sound
	soundPlayer.volume_db = volume
	soundPlayer.play()
	# kill after finished
	soundPlayer.finished.connect(func(): soundPlayer.queue_free())

func debug(message) -> void:
	var stack = get_stack()
	if stack.size() > 1:
		var caller = stack[1]
		var source = caller.get("source", "unknown")
		var line := str(caller.get("line", -1))
		print("[" + source + ":" + line + "]: " + str(message))
	else:
		print("[unknown]: " + str(message))
