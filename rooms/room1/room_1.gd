extends Node2D

@export var room_entered = false
@export var enemies_count = 6

const BALL_AND_CHAIN = "res://enemies/ball_and_chain_robot/ball_and_chain_robot.tscn"
const ENEMIES = [BALL_AND_CHAIN]

func _ready():
	Signalbus.room_entered.connect(on_room_entered)

func spawn_enemy(location: Vector2):
	var new_enemy = ENEMIES.pick_random().instantiate()
	new_enemy.global_position = location
	

func on_room_entered():
	for marker in %Spawns.get_children():
		spawn_enemy(marker.global_position)
		

func on_room_cleared():
	pass
	

func _on_room_entered_area_entered(area):
	if room_entered == false:
		room_entered = true
		Signalbus.room_entered.emit()
