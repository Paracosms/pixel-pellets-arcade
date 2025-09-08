extends CharacterBody2D

@onready var phaseScenes = [
	preload("res://scenes/bosses/boss2/atk0.tscn"),
	preload("res://scenes/bosses/boss2/atk1.tscn")
]

@export var phase : Node
var isLookingAtPlayer : bool = false
var isMoving : bool = false
var currentPhaseIndex : int

func _physics_process(delta: float) -> void:
	# getMovementPattern updates variables here that boss2 can execute
	phase.getMovementPattern()
	
	if isLookingAtPlayer:
		look_at(Globals.playerPos)
	if isMoving:
		velocity = phase.getVelocity()
		move_and_slide()

func transition():
	### TODO: you left off working on the transition. notes are in the discord #projects
	var phaseIndex = randi_range(0, 1) ### UPDATE LATER
	while phaseIndex == currentPhaseIndex:
		phaseIndex = randi_range(0, 1) ### UPDATE LATER
	
	print("transitioning to " + str(phaseIndex))
	var nextPhase = phaseScenes[phaseIndex].instantiate()
	currentPhaseIndex = phaseIndex
	phase.queue_free()
	phase = nextPhase
	add_child(phase)

func _on_hurt_player_area_entered(area: Area2D) -> void:
	get_tree().call_group("game", "kill")
