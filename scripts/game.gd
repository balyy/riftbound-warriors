extends Node2D


const ROOM01 = preload("res://rooms/room1/room1.tscn")
const ROOM02 = preload("res://rooms/room2/room2.tscn")
const ROOM03 = preload("res://rooms/room3/room3.tscn")
const ROOM04 = preload("res://rooms/room4/room4.tscn")
const ROOM05 = preload("res://rooms/room5/room5.tscn")
const ROOMS = [ROOM01, ROOM02, ROOM03, ROOM04, ROOM05]
#const ROOMS = [ROOM01]

const ENDROOM01 = preload("res://rooms/endroom1/endroom1.tscn")
const ENDROOMS = [ENDROOM01]

var score = 0

func _ready():
	Signalbus.room_load_next.connect(on_room_load_next)
	Signalbus.player_died.connect(on_player_died)
	loaded_rooms.append(%Rooms.get_children()[0])

func on_room_load_next():
	load_room()


var loaded_rooms: Array
func load_room():
	for i in range(5):
		print("load room")
		var new_room
		new_room = ROOMS.pick_random().instantiate()
		
		if loaded_rooms.is_empty():
			new_room.global_position = %ConnectionPoint.global_position
		if loaded_rooms.size() == 5:
			new_room = ENDROOMS.pick_random().instantiate()
			new_room.global_position = loaded_rooms[-1].connection_point.global_position
		else:
			print("loaded rooms[-1]")
			print(loaded_rooms[-1])
			print("connection point global pos")
			print(loaded_rooms[-1].connection_point.global_position)
			new_room.global_position = loaded_rooms[-1].connection_point.global_position
			
		print("new room global pos:")
		print(new_room.global_position)
		loaded_rooms.append(new_room)
		
		%Rooms.add_child(new_room)

func unload_rooms():
	for room in loaded_rooms:
		room.queue_free()
		loaded_rooms.erase(room)

func on_player_died():
	%GameOver.visible = true
	%FinalScoreLabel.text = "Your score: " + str(score)
	

func _on_button_pressed():
	Signalbus.room_cleared.emit()

func _on_button_2_pressed():
	Signalbus.room_load_next.emit()
