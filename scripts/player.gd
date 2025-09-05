extends CharacterBody2D

var input = Vector2.ZERO
const SPEED = 300
signal damagePlayer

# call movement function on each player frame
func _physics_process(delta):
	player_movement(delta)

# find movement direction
func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

# calculate movement and move the player
func player_movement(delta):
	velocity = get_input() * SPEED
	move_and_slide()

func die():
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	emit_signal("damagePlayer")
