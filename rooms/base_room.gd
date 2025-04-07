extends Resource
class_name Room

@export var room_entered = false
@export var enemies_count = 0

const BALL_AND_CHAIN = preload("res://enemies/ball_and_chain_robot/ball_and_chain_robot.tscn")
const ENEMIES = [BALL_AND_CHAIN]



func spawn_enemy(enemies_parent : Node2D, location: Vector2):
	var new_enemy = ENEMIES.pick_random().instantiate()
	print("spawn")
	new_enemy.global_position = location
	enemies_parent.add_child(new_enemy)
	

func on_room_entered(enemies_parent, spawn_marker_parent : Node2D):
	print("room entered signal received")
	for marker in spawn_marker_parent.get_children():
		spawn_enemy(enemies_parent, marker.global_position)
		enemies_count += 1
		

func on_room_cleared():
	Signalbus.room_load_next.emit()
	
