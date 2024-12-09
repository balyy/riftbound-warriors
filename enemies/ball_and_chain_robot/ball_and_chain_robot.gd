extends CharacterBody2D

@export var sprite:AnimatedSprite2D

var random = RandomNumberGenerator.new()
var enemy = null
enum Direction {LEFT, RIGHT}


func _process(_delta: float) -> void:
	check_detection_box_occupation()
	z_index = global_position.y


func to_vector2(target):
	return Vector2(target.global_position.x, target.global_position.y)


func move_towards(delta, target: Vector2):
	var direction = global_position.direction_to(calculate_attack_position(target))
	rotate_towards_target(target)
	
	velocity += (direction * 1000 * delta)
	velocity = velocity.limit_length(100)
	move_and_slide()


var facing = Direction.RIGHT
func rotate_towards_target(target: Vector2):
	if target.x < global_position.x and facing != Direction.LEFT:
		scale.x *= -1
		facing = Direction.LEFT
		
	elif target.x > global_position.x and facing != Direction.RIGHT:
		scale.x *= -1
		facing = Direction.RIGHT


func calculate_attack_position(target: Vector2):
	var position: Vector2
	if global_position.distance_to(Vector2(target.x + 50, target.y)) > global_position.distance_to(Vector2(target.x - 50, target.y)):
		position = Vector2(target.x - 40, target.y) + Vector2(random.randf_range(-20, 20), random.randf_range(-20, 20))
	else:
		position = Vector2(target.x + 40, target.y) + Vector2(random.randf_range(-20, 20), random.randf_range(-20, 20))
		
	return position


# IDLE STATE

func _on_idle_state_processing(_delta: float) -> void:
	sprite.play("idle")


# CHASE STATE

var detection_box_occupied = false
func _on_detection_box_area_entered(area: Area2D) -> void:
	detection_box_occupied = true
	$StateChart.send_event("enemy_entered")
	enemy = area.get_parent()


func _on_detection_box_area_exited(_area: Area2D) -> void:
	detection_box_occupied = false
	$StateChart.send_event("enemy_left")


func check_detection_box_occupation():
	if detection_box_occupied == true:
		$StateChart.send_event("enemy_entered") # Ez ún. "Eventfosás". Később optimalizálni kéne még


func _on_chase_state_processing(delta: float) -> void:
	sprite.play("run")
	move_towards(delta, to_vector2((enemy)))
	check_detection_box_occupation()
	check_attack_position(to_vector2(enemy))


# CHARGE STATE

func _on_animated_sprite_2d_animation_finished() -> void:
	$StateChart.send_event("charge_finished")


func _on_charge_state_processing(_delta: float) -> void:
	sprite.play("charge")
	check_attack_box_occupation()


# ATTACK STATE

var attack_box_occupied = false
func _on_attack_box_area_entered(area: Area2D) -> void:
	attack_box_occupied = true


func _on_attack_box_area_exited(_area: Area2D) -> void:
	attack_box_occupied = false
	

func check_attack_box_occupation():
	if attack_box_occupied != true:
		$StateChart.send_event("enemy_out_of_range")


func check_attack_position(target: Vector2):
	if round(global_position.y + random.randf_range(-20, 20)) == round(target.y)and attack_box_occupied:
		$StateChart.send_event("enemy_in_range") 


func _on_attack_state_processing(delta: float) -> void:
	sprite.play("attack")
	check_attack_box_occupation()


# NEW BELOW
