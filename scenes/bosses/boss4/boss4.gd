extends CharacterBody2D

# preload all atks here
@onready var phaseScenes = [
	preload("res://scenes/bosses/boss4/atk0.tscn"),
]

@export var health : int = 50
@export var phase : Node # current atk phase
var isLookingAtPlayer : bool = false
var currentPhaseIndex : int
var transitionAtHealthPercent = [75, 50, 25] # the boss will force a transition at 75%, 50% and 25% respectively, no matter what

func takeDamage():
	Globals.bossHealth -= 1
	if Globals.bossHealth == 0:
		Globals.spawnNextBoss()
		queue_free()
	
	for percent in transitionAtHealthPercent:
		if (Globals.bossHealth == health * percent * 0.01):
			transition()

func _ready() -> void:
	Globals.bossHealth = health # number of bullets before death
	Globals.maxBossHealth = health
	Globals.changeBackgroundHue(0.88) # update background to be yellow (decrement by 0.06)

func _physics_process(_delta: float) -> void:
	# getMovementPattern updates variables here that the boss can execute
	phase.getMovementPattern()
	
	if isLookingAtPlayer:
		look_at(Globals.playerPos)
	
	velocity = phase.getVelocity()
	move_and_slide()

func transition():
	var phaseIndex = randi_range(0, phaseScenes.size() - 1)
	#while phaseIndex == currentPhaseIndex:
	#	phaseIndex = randi_range(0, phaseScenes.size() - 1)
	
	# phaseIndex = 0 ### for debug purposes
	
	Globals.debug("transitioning to " + str(phaseIndex))
	var nextPhase = phaseScenes[phaseIndex].instantiate()
	currentPhaseIndex = phaseIndex
	phase.queue_free()
	phase = nextPhase
	add_child(phase)

func _on_hurt_player_area_entered(_area: Area2D) -> void:
	get_tree().call_group("game", "kill")
