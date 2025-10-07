### DEFAULT BOSS TEMPLATE
# bosses are numbered by sides, (e.g. boss2 is line, boss3 is triangle)
# exceptions to this are boss0 (template) and boss1 (tutorial)
# when copying this template, copy both boss0.gd/tscn and atk0.gd/tscn

extends CharacterBody2D

# preload all atks here
@onready var phaseScenes = [
	preload("res://scenes/bosses/boss3/atk0.tscn"),
	preload("res://scenes/bosses/boss3/atk1.tscn"),
	preload("res://scenes/bosses/boss3/atk2.tscn"),
]

@export var health : int = 100
@export var phase : Node # current atk phase
var isLookingAtPlayer : bool = false
var currentPhaseIndex : int
var transitionAtHealthPercent = [75, 50, 25] # the boss will force a transition at 75%, 50% and 25% respectively, no matter what

func takeDamage():
	Globals.bossHealth -= 1
	if Globals.bossHealth == 0:
		queue_free()
	
	for percent in transitionAtHealthPercent:
		if (Globals.bossHealth == health * percent * 0.01):
			transition()

func _ready() -> void:
	Globals.bossHealth = health # number of bullets before death
	Globals.maxBossHealth = health
	Globals.changeBackgroundHue(0.94) # update background to be orange

func _physics_process(_delta: float) -> void:
	# getMovementPattern updates variables here that the boss can execute
	phase.getMovementPattern()
	
	if isLookingAtPlayer:
		look_at(Globals.playerPos)
	
	velocity = phase.getVelocity()
	move_and_slide()

func transition():
	var phaseIndex = randi_range(0, phaseScenes.size() - 1)
	
	while phaseIndex == currentPhaseIndex:
		phaseIndex = randi_range(0, phaseScenes.size() - 1)
	
	# phaseIndex = 1 ### for debug purposes
	
	Globals.debug("transitioning to " + str(phaseIndex))
	var nextPhase = phaseScenes[phaseIndex].instantiate()
	currentPhaseIndex = phaseIndex
	phase.queue_free()
	phase = nextPhase
	add_child(phase)

func _on_hurt_player_area_entered(_area: Area2D) -> void:
	get_tree().call_group("game", "kill")
