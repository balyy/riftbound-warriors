extends CharacterBody2D

@export var sprite:AnimatedSprite2D
var enemy = null

func _process(delta: float) -> void:
	check_detection_box_occupation()

var rotated = false
func move_towards(delta, target):
	var direction = global_position.direction_to(target.global_position)
	if target.global_position.x < global_position.x and rotated == false:
		scale.x = -1
		rotated = true
		print("rotate left")
	if target.global_position.x > global_position.x and rotated == true:
		scale.x = 1
		rotated = false
		print("rotate right")
	
	velocity += (direction * 1000 * delta)
	velocity = velocity.limit_length(100)
	move_and_slide()


var detection_box_occupied = false
func _on_detection_box_area_entered(area: Area2D) -> void:
	detection_box_occupied = true
	enemy = area.get_parent()


func _on_detection_box_area_exited(area: Area2D) -> void:
	detection_box_occupied = false


func check_detection_box_occupation():
	if detection_box_occupied == true:
		$StateChart.send_event("enemy_entered")
	else:
		$StateChart.send_event("enemy_left")


func _on_chase_state_processing(delta: float) -> void:
	move_towards(delta, enemy)
	sprite.play("run")


func _on_idle_state_processing(delta: float) -> void:
	sprite.play("idle")
	
