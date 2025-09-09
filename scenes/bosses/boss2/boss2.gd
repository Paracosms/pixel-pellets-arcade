extends CharacterBody2D

@onready var phaseScenes = [
	preload("res://scenes/bosses/boss2/atk0.tscn"),
	preload("res://scenes/bosses/boss2/atk1.tscn"),
	preload("res://scenes/bosses/boss2/atk2.tscn"),
	preload("res://scenes/bosses/boss2/atk3.tscn")
]

@export var health : int = 200
@export var phase : Node
var isLookingAtPlayer : bool = false
var isMoving : bool = false
var currentPhaseIndex : int

func takeDamage():
	Globals.bossHealth -= 1
	if Globals.bossHealth == 0:
		queue_free()

func _ready() -> void:
	Globals.bossHealth = health # number of bullets before death
	Globals.maxBossHealth = health

func _physics_process(delta: float) -> void:
	
	#print("boss 2 physics function: global player pos - global boss pos = " + str(Globals.playerPos.x - global_position.x))
	
	# getMovementPattern updates variables here that boss2 can execute
	phase.getMovementPattern()
	
	if isLookingAtPlayer:
		look_at(Globals.playerPos)
	if isMoving:
		velocity = phase.getVelocity()
		move_and_slide()

func transition():
	var phaseIndex = randi_range(0, phaseScenes.size() - 1)
	while phaseIndex == currentPhaseIndex:
		phaseIndex = randi_range(0, phaseScenes.size() - 1)
	
	# phaseIndex = 3 ### DEBUG, SET TEST PHASE HERE
	
	print("transitioning to " + str(phaseIndex))
	var nextPhase = phaseScenes[phaseIndex].instantiate()
	currentPhaseIndex = phaseIndex
	phase.queue_free()
	phase = nextPhase
	add_child(phase)

func _on_hurt_player_area_entered(area: Area2D) -> void:
	get_tree().call_group("game", "kill")
