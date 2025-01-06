extends CharacterBody2D


@export var sprite: AnimatedSprite2D
@export var state_chart: StateChart


enum Direction {LEFT, RIGHT}


var input = Vector2.ZERO
func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()

var facing = Direction.RIGHT
func rotate_character(input):
	print("rotate character")
	if input.x < 0 && facing == Direction.RIGHT:
		scale.x *= -1
		facing = Direction.LEFT
		print(input.x)
		print("input.x < 0")
	if input.x > 0 && facing == Direction.LEFT:
		scale.x *= -1
		facing = Direction.RIGHT
		print(input.x)
		print("input.x > 0")
	

func move(delta):
	var input = get_input()
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
		$StateChart.send_event("idle")
	else:
		$StateChart.send_event("moving")
		rotate_character(input)
		velocity += (input * 2000 * delta)
	velocity = velocity.limit_length(200)
	move_and_slide()


func _process(delta: float) -> void:
	move(delta)
