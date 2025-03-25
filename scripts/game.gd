extends Node2D


const ROOM01 = preload("res://rooms/room1/room_1.tscn")
#const ROOM02
const ROOMS = [ROOM01]


func _ready():
	Signalbus.room_load_next.connect(on_room_load_next)

func on_room_load_next():
	pass


var loaded_rooms: Array
func load_room():
	print("load room")
	var new_room
	new_room = ROOMS.pick_random().instantiate()
	
	if loaded_rooms.is_empty():
		new_room.global_position = %ConnectionPoint.global_position
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
