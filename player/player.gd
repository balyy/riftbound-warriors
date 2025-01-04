extends CharacterBody2D


var input = Vector2.ZERO
func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()


func move(delta):
	var input = get_input()
	
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity += (input * 1000 * delta)
	velocity = velocity.limit_length(100)
	move_and_slide()


func _process(delta: float) -> void:
	move(delta)
